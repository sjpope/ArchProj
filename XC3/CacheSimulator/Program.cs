using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

// Example: dotnet run -- 32 1024 32 1 addy.txt

public class CacheLine
{
    public bool Valid;
    public ulong Tag;
    public int UsageCounter; 
}

public class CacheSet
{
    private CacheLine[] lines;
    public CacheSet(int ways)
    {
        lines = new CacheLine[ways];
        for (int i = 0; i < ways; i++)
        {
            lines[i] = new CacheLine { Valid = false, Tag = 0, UsageCounter = 0 };
        }
    }

    public bool Access(ulong tag, int time)
    {
        // Check hit
        for (int i = 0; i < lines.Length; i++)
        {
            if (lines[i].Valid && lines[i].Tag == tag)
            {
                // Hit 
                lines[i].UsageCounter = time;
                return true;
            }
        }

        // Miss - find victim using LRU 
        int victim = 0;
        int oldest = int.MaxValue;
        for (int i = 0; i < lines.Length; i++)
        {
            if (!lines[i].Valid)
            {
                victim = i;
                oldest = -1;
                break;
            }
            if (lines[i].UsageCounter < oldest)
            {
                oldest = lines[i].UsageCounter;
                victim = i;
            }
        }

        // Replace victim line
        lines[victim].Valid = true;
        lines[victim].Tag = tag;
        lines[victim].UsageCounter = time;
        return false;
    }
}

public class Cache
{
    private int B;   // Block size
    private int I;   // Number of sets
    private int A;   // Associativity
    private int blockOffsetBits;
    private int indexBits;
    private CacheSet[] sets;

    public Cache(int N, int B, int I, int A)
    {
        this.B = B;
        this.I = I;
        this.A = A;

        blockOffsetBits = Log2(B);
        indexBits = Log2(I);

        sets = new CacheSet[I];
        for (int j = 0; j < I; j++)
            sets[j] = new CacheSet(A);
    }

    public bool Access(ulong address, int time)
    {
        ulong index = (address >> blockOffsetBits) & (ulong)(I - 1);
        ulong tag = address >> (blockOffsetBits + indexBits);
        return sets[index].Access(tag, time);
    }

    private int Log2(int x)
    {
        int r = 0;
        while ((1 << r) < x) r++;
        return r;
    }
}

public static class Program
{
    public static void Main(string[] args)
    {
        if (args.Length < 5)
        {
            Console.WriteLine("Usage: <N> <B> <I> <A> <filename>");
            return;
        }

        int N = int.Parse(args[0]);
        int B = int.Parse(args[1]);
        int I = int.Parse(args[2]);
        int A = int.Parse(args[3]);
        string filename = args[4];

        if (!File.Exists(filename))
        {
            Console.WriteLine("File not found.");
            return;
        }

        List<ulong> addresses = new List<ulong>();
        using (var sr = new StreamReader(filename))
        {
            string line;
            while ((line = sr.ReadLine()) != null)
            {
                line = line.Trim();
                if (line.StartsWith("x", StringComparison.OrdinalIgnoreCase))
                {
                    string hex = line.Substring(1);
                    ulong addr = ulong.Parse(hex, NumberStyles.HexNumber);
                    addresses.Add(addr);
                }
            }
        }

        Cache cache = new Cache(N, B, I, A);

        int blockOffsetBits = Log2(B);
        int indexBits = Log2(I);

        Console.WriteLine("Index\tTag\tH/M");
        for (int i = 0; i < addresses.Count; i++)
        {
            ulong addr = addresses[i];
            ulong index = (addr >> blockOffsetBits) & (ulong)(I - 1);
            ulong tag = addr >> (blockOffsetBits + indexBits);

            bool hit = cache.Access(addr, i);
            Console.WriteLine($"x{index:X}\tx{tag:X}\t{(hit ? "H" : "M")}");
        }
    }

    private static int Log2(int x)
    {
        int r = 0;
        while ((1 << r) < x) r++;
        return r;
    }
}
