using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

// dotnet run -- 32 1024 32 1 LRU addy.txt

public enum ReplacementPolicy
{
    LRU,
    MRU,
    OPT
}

public class CacheLine
{
    public bool Valid { get; set; }
    public ulong Tag { get; set; }
    public int UsageCounter { get; set; } // For LRU/MRU. Higher means more recently used or less recently used depending on interpretation.
}

public class CacheSet
{
    private readonly CacheLine[] _lines;
    private readonly ReplacementPolicy _policy;
    private readonly int _setSize;

    private readonly List<ulong> _futureAddresses;
    private readonly int _currentAccessIndex;

    public CacheSet(int ways, ReplacementPolicy policy, List<ulong> futureAddresses, int currentAccessIndex)
    {
        _lines = new CacheLine[ways];
        for (int i = 0; i < ways; i++)
        {
            _lines[i] = new CacheLine { Valid = false, Tag = 0, UsageCounter = 0 };
        }

        _policy = policy;
        _setSize = ways;
        _futureAddresses = futureAddresses;
        _currentAccessIndex = currentAccessIndex;
    }

    public bool Access(ulong tag, int globalCounter)
    {
        // Check for hit
        for (int i = 0; i < _setSize; i++)
        {
            if (_lines[i].Valid && _lines[i].Tag == tag)
            {
                // Hit - update usageCounter or do the logic for LRU/MRU
                UpdateUsageOnHit(i, globalCounter);
                return true;
            }
        }

        // Miss - must replace a line
        ReplaceLine(tag, globalCounter);
        return false;
    }

    private void UpdateUsageOnHit(int lineIndex, int globalCounter)
    {
        switch (_policy)
        {
            case ReplacementPolicy.LRU:
                // For LRU, on hit, set usageCounter to globalCounter so that this line is the most recently used
                _lines[lineIndex].UsageCounter = globalCounter;
                break;
            case ReplacementPolicy.MRU:
                _lines[lineIndex].UsageCounter = globalCounter;
                break;
            case ReplacementPolicy.OPT:
                // On hit, no special usage needed. The OPT policy uses future lookups, not usageCounter.
                // However, we can store usageCounter for completeness but it's not used by OPT.
                _lines[lineIndex].UsageCounter = globalCounter;
                break;
        }
    }

    private void ReplaceLine(ulong tag, int globalCounter)
    {
        int victimIndex = 0;

        switch (_policy)
        {
            case ReplacementPolicy.LRU:
                // For LRU, victim is the line with the smallest usageCounter (least recently used)
                int minUsage = int.MaxValue;
                for (int i = 0; i < _setSize; i++)
                {
                    if (!_lines[i].Valid)
                    {
                        victimIndex = i;
                        minUsage = -1;
                        break;
                    }
                    if (_lines[i].UsageCounter < minUsage)
                    {
                        minUsage = _lines[i].UsageCounter;
                        victimIndex = i;
                    }
                }

                _lines[victimIndex].Tag = tag;
                _lines[victimIndex].Valid = true;
                _lines[victimIndex].UsageCounter = globalCounter; // now this line is the most recently used
                break;

            case ReplacementPolicy.MRU:
                // For MRU, victim is the line with the largest usageCounter (most recently used),
                // because we want to replace the most recently used line (an unusual but defined policy).
                int maxUsage = int.MinValue;
                for (int i = 0; i < _setSize; i++)
                {
                    if (!_lines[i].Valid)
                    {
                        victimIndex = i;
                        maxUsage = int.MaxValue;
                        break;
                    }
                    if (_lines[i].UsageCounter > maxUsage)
                    {
                        maxUsage = _lines[i].UsageCounter;
                        victimIndex = i;
                    }
                }

                _lines[victimIndex].Tag = tag;
                _lines[victimIndex].Valid = true;
                _lines[victimIndex].UsageCounter = globalCounter; 
                break;

            case ReplacementPolicy.OPT:

                int chosenIndex = 0;
                int furthestUse = -1;
                for (int i = 0; i < _setSize; i++)
                {
                    if (!_lines[i].Valid)
                    {
                        chosenIndex = i;
                        furthestUse = int.MaxValue;
                        break;
                    }
                    // Find next use
                    ulong currentTag = _lines[i].Tag;
                    int nextUseIndex = FindNextUse(_futureAddresses, _currentAccessIndex, currentTag, _lines[i]);
                    
                    if (nextUseIndex == -1) 
                    {
                        chosenIndex = i;
                        furthestUse = int.MaxValue; // best possible victim
                        break;
                    }
                    else if (nextUseIndex > furthestUse)
                    {
                        // This line is used even further in the future, pick it
                        chosenIndex = i;
                        furthestUse = nextUseIndex;
                    }
                    else if (furthestUse == -1)
                    {
                        chosenIndex = i;
                        furthestUse = nextUseIndex;
                    }
                }

                _lines[chosenIndex].Tag = tag;
                _lines[chosenIndex].Valid = true;
                _lines[chosenIndex].UsageCounter = globalCounter;
                break;
        }
    }

    
    private int FindNextUse(List<ulong> futureAddresses, int currentIndex, ulong targetTag, CacheLine line)
    {
        // We'll rely on static global parameters set in main.
        for (int i = currentIndex + 1; i < futureAddresses.Count; i++)
        {
            ulong addr = futureAddresses[i];
            ulong tag, index;
            ExtractTagIndex(addr, out tag, out index);
            // If the tag matches the line's tag, and the index matches this set, it's a future use
            // Wait, we don't have the set index here easily. 
            // We must fix that. Let's also store a static reference to how to extract index and tag.

            // The calling code can store the set index and block offset bits as static. Let's do that now.
            if (tag == targetTag && GetIndexFromAddress(addr) == GetCurrentSetIndex())
            {
                return i;
            }
        }
        return -1;
    }

    // We will use static fields to store parameters needed for indexing:
    private static int _blockOffsetBits;
    private static int _indexBits;
    private static int _setIndex;
    public static void InitializeStaticParams(int blockOffsetBits, int indexBits)
    {
        _blockOffsetBits = blockOffsetBits;
        _indexBits = indexBits;
    }

    public void SetSetIndex(int index)
    {
        _setIndex = index;
    }

    private static void ExtractTagIndex(ulong address, out ulong tag, out ulong index)
    {
        ulong indexMask = (ulong)((1 << _indexBits) - 1);
        index = (address >> _blockOffsetBits) & indexMask;
        tag = address >> (_blockOffsetBits + _indexBits);
    }

    private static ulong GetIndexFromAddress(ulong address)
    {
        ulong indexMask = (ulong)((1 << _indexBits) - 1);
        return (address >> _blockOffsetBits) & indexMask;
    }

    private ulong GetCurrentSetIndex()
    {
        // We need the set index that this CacheSet represents. We do not have a direct mapping 
        // from here because the Cache class manages that. A real design would pass the set index in constructor.
        // Let's assume the Cache class sets it after creation. We'll store it as instance field if needed.
        return (ulong)_setIndex;
    }
}

public class Cache
{
    private readonly int _N; // total address space bits
    private readonly int _B; // block size in bytes (power of two)
    private readonly int _I; // number of sets (power of two)
    private readonly int _A; // ways of associativity

    private readonly ReplacementPolicy _policy;
    private readonly CacheSet[] _sets;

    private int blockOffsetBits;
    private int indexBits;

    private readonly List<ulong> _addresses; // For OPT policy, we need all future addresses.

    public Cache(int N, int B, int I, int A, ReplacementPolicy policy, List<ulong> addresses)
    {
        _N = N;
        _B = B;
        _I = I;
        _A = A;
        _policy = policy;
        _addresses = addresses;

        // Compute bits
        // blockOffsetBits = log2(B)
        blockOffsetBits = Log2(B);
        // indexBits = log2(I)
        indexBits = Log2(I);

        // Create sets
        _sets = new CacheSet[I];
        CacheSet.InitializeStaticParams(blockOffsetBits, indexBits);

        for (int i = 0; i < I; i++)
        {
            _sets[i] = null; // Defer creation until first access, so we can pass currentAccessIndex properly.
        }
    }

    public bool Access(ulong address, int currentAccessIndex)
    {
        // Compute index and tag
        ulong index = ExtractIndex(address);
        ulong tag = ExtractTag(address);

        // If we haven't created the set yet, do so now:
        if (_sets[index] == null)
        {
            // Create a new CacheSet
            // The CacheSet constructor: (int ways, ReplacementPolicy policy, List<ulong> futureAddresses, int currentAccessIndex)
            CacheSet set = new CacheSet(_A, _policy, _addresses, currentAccessIndex);
            set.SetSetIndex((int)index);
            _sets[index] = set;
        }

        // Access the cache set
        // Use currentAccessIndex as globalCounter
        bool hit = _sets[index].Access(tag, currentAccessIndex);
        return hit;
    }

    private ulong ExtractTag(ulong address)
    {
        // tag = address >> (blockOffsetBits + indexBits)
        return address >> (blockOffsetBits + indexBits);
    }

    private ulong ExtractIndex(ulong address)
    {
        // index = (address >> blockOffsetBits) & ((1 << indexBits) - 1)
        ulong mask = (ulong)((1 << indexBits) - 1);
        return (address >> blockOffsetBits) & mask;
    }

    private int Log2(int x)
    {
        // Compute log2 of a power-of-two integer
        int result = 0;
        while ((1 << result) < x) result++;
        return result;
    }
}

/// <summary>
/// Main class that parses input, runs the simulation, and prints the output.
/// </summary>
public static class Program
{
    // We need global parameters for the OPT policy to re-derive tags and indexes.
    // We'll store static references here. This is a simplification/hack.
    private static int GlobalN;
    private static int GlobalB;
    private static int GlobalI;
    private static int GlobalA;
    private static ReplacementPolicy GlobalPolicy;

    public static void Main(string[] args)
    {
        if (args.Length < 6)
        {
            Console.WriteLine("Usage: <N> <B> <I> <A> <Policy> <filename>");
            return;
        }

        // Parse arguments
        // N: total size of address space in 2^N bytes
        // B: block size in bytes, power of two
        // I: number of sets, power of two
        // A: associativity ways
        // Policy: LRU, MRU, OPT
        // filename: input file

        GlobalN = int.Parse(args[0]);
        GlobalB = int.Parse(args[1]);
        GlobalI = int.Parse(args[2]);
        GlobalA = int.Parse(args[3]);
        string policyStr = args[4];
        string filename = args[5];

        if (!File.Exists(filename))
        {
            Console.WriteLine("Input file wasn't found bro.");
            return;
        }

        ReplacementPolicy policy;
        switch (policyStr.ToUpperInvariant())
        {
            case "LRU":
                policy = ReplacementPolicy.LRU;
                break;
            case "MRU":
                policy = ReplacementPolicy.MRU;
                break;
            case "OPT":
                policy = ReplacementPolicy.OPT;
                break;
            default:
                Console.WriteLine("Unknown policy bro. Use LRU, MRU, or OPT.");
                return;
        }
        GlobalPolicy = policy;

        // Read addresses from file
        List<ulong> addresses = new List<ulong>();
        using (var sr = new StreamReader(filename))
        {
            string line;
            while ((line = sr.ReadLine()) != null)
            {
                line = line.Trim();
                if (line.StartsWith("x", StringComparison.OrdinalIgnoreCase))
                {
                    string hexPart = line.Substring(1);
                    // Parse as hex
                    ulong addr = ulong.Parse(hexPart, NumberStyles.HexNumber);
                    addresses.Add(addr);
                }
            }
        }

        // Create cache
        Cache cache = new Cache(GlobalN, GlobalB, GlobalI, GlobalA, policy, addresses);

        // For each address, we must print:
        //  i) The index of the address in hex (the cache index field)
        // ii) The tag of the address in hex
        // iii) Hit/Miss (H/M)
        //
        // We'll recompute index and tag for printing consistently.

        // Compute blockOffsetBits and indexBits for printing:
        int blockOffsetBits = Log2(GlobalB);
        int indexBits = Log2(GlobalI);

        Console.WriteLine($"index\t tag\t H/M");
        for (int i = 0; i < addresses.Count; i++)
        {
            ulong addr = addresses[i];
            (ulong tag, ulong index) = ExtractTagIndex(addr, blockOffsetBits, indexBits);

            bool hit = cache.Access(addr, i);
            string result = hit ? "H" : "M";

            // Print in the format: <index in hex>\t<tag in hex>\tH/M
            // Prefix with 'x' to match format examples
            Console.WriteLine($"x{index:X}\t x{tag:X}\t {result}");
        }
    }

    private static (ulong tag, ulong index) ExtractTagIndex(ulong address, int blockOffsetBits, int indexBits)
    {
        ulong indexMask = (ulong)((1 << indexBits) - 1);
        ulong index = (address >> blockOffsetBits) & indexMask;
        ulong tag = address >> (blockOffsetBits + indexBits);
        return (tag, index);
    }

    private static int Log2(int x)
    {
        int result = 0;
        while ((1 << result) < x) result++;
        return result;
    }
}
