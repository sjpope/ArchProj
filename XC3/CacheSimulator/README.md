# Cache Simulator

This project is a cache simulator implemented in C#. It can simulate various cache configurations, including direct-mapped and set-associative caches, with different replacement policies (LRU, MRU, and an "OPT" look-ahead policy).

## Requirements

- .NET SDK (e.g., .NET 6 or newer)
- A text file containing a list of hex addresses to analyze.

## Installation

1. Clone or download this repository to your local machine.
2. Ensure you have a valid .NET environment by running:
    ```bash
    dotnet --version
    ```
3. If it prints a version number, .NET is available.

## Building the Project

To build the project, navigate to the directory containing the `Program.cs` file and run:

```bash
dotnet build
```

This will create a binary under `./bin/Debug/netX/` (where X depends on your .NET version).

## Running the Simulator

The simulator requires six arguments:

```bash
dotnet run -- <N> <B> <I> <A> <Policy> <filename>
```

Where:

- `N`: The total size of the address space is 2^N bytes.
  - For example, N=32 means addresses are 32 bits (0 to 2^32 - 1).
- `B`: The block size in bytes. Must be a power of two.
  - For example, B=1024 means each cache line contains 1024 bytes.
- `I`: The number of sets in the cache. Must be a power of two.
  - For example, I=128 means there are 128 sets.
- `A`: The associativity (number of ways).
  - For example, A=1 for direct-mapped, A=2 for 2-way set associative.
- `Policy`: The replacement policy. One of LRU, MRU, or OPT.
- `filename`: The path to your text file containing addresses.
  - Each line in the file should be in the form `xFFFF` (hex with a leading x).

### Example

Given an `addy.txt` file like the one in the repository:

```plaintext
x0000
x0004
x0A10
x0A14
xFFFF
x10000
x1A10
x1A14
```

Run the simulator as follows:

```bash
dotnet run -- 32 1024 128 1 LRU addy.txt
```

This command sets:

- `N=32` (32-bit address space)
- `B=1024` bytes per block
- `I=128` sets
- `A=1` way (direct-mapped)
- `Policy=LRU`
- Input file: `addy.txt`

The simulator will print lines for each address, showing the index, tag, and whether it was a hit or a miss.

### Sample Output Format

The output might look like:

```shell
x0    x0    M
x0    x0    H
xA    xX    M
...
```

Where each line is `<index in hex>\t<tag in hex>\tH/M`.

### Adjusting Parameters

Feel free to experiment with different values of `N`, `B`, `I`, and `A`. Just remember:

- `B` and `I` must be powers of two.
- If you change `N` significantly, ensure your addresses in `addy.txt` fall within the valid address range (0 to 2^N - 1).
- For the OPT policy, the simulator attempts to look ahead in the address list to determine the optimal block to evict next. Ensure that you provide enough addresses in your input file for the policy to make meaningful decisions.

## Support

If you encounter any issues or have questions, please open an issue or contact the maintainer at sjpope03@gmail.com