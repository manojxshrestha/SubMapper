<p align="center">
  <img src="https://github.com/user-attachments/assets/e07dc8e8-0d6b-4848-8b5d-f1f564f87f35" alt="SubMapper">
</p>


[![GitHub stars](https://img.shields.io/github/stars/manojxshrestha/SubMapper)](https://github.com/manojxshrestha/SubMapper/stargazers)  
[![GitHub forks](https://img.shields.io/github/forks/manojxshrestha/SubMapper)](https://github.com/manojxshrestha/SubMapper/network)

# SubMapper 🧑🏻‍💻

SubMapper is a Bash-based subdomain enumeration tool designed to discover subdomains of a target domain using multiple sources and tools. It uses popular well-known tools like Amass, Assetfinder, Subfinder, crt.sh, and the Wayback Machine (web.archive.org) to gather a comprehensive list of subdomains, which are then deduplicated and saved for further analysis.

## Features
- Collects subdomains from multiple sources:
  - **Amass**: Passive enumeration.
  - **Assetfinder**: Subdomain discovery.
  - **Subfinder**: Fast and silent subdomain enumeration.
  - **crt.sh**: Certificate transparency logs.
  - **Archive**: Historical data from the Wayback Machine.
- Combines results and removes duplicates efficiently.
- Color-coded output for better readability.
- Saves results to a single file for easy access.
- Tracks and displays execution time.

## Required Tools
To run SubMapper, you need the following tools installed on your system:
- **Bash** (pre-installed on most Linux/macOS systems)
- **curl** (for API requests)
- **jq** (for parsing JSON responses from crt.sh)
- **Amass** (`go install github.com/OWASP/Amass/v3/...@latest`)
- **Assetfinder** (`go install github.com/tomnomnom/assetfinder@latest`)
- **Subfinder** (`go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest`)
- **anew** (`go install github.com/tomnomnom/anew@latest`) - Optional, for efficient deduplication

### Installation
1. Clone or download this script:
   ```bash
   git clone https://github.com/manojxshrestha/SubMapper.git
   cd SubMapper
   chmod +x submapper.sh
   ```
2. Run the script:
   ```bash
   ./submapper.sh
   ```

## Usage
Run the script and provide a target domain when prompted. SubMapper will fetch subdomains, combine them, and save the results in a directory named after the target domain.

### Basic Command
```bash
./submapper.sh
```
- You’ll be prompted to enter a domain (e.g., `example.com`).

### Usage Examples
1. **Enumerate subdomains for a domain:**
   ```bash
   ./submapper.sh
   Enter the Target Domain (e.g. example.com): google.com
   ```
   - Output: Subdomains are saved in `google.com/all_subdomains.txt`.

2. **Run in a non-interactive script:**
   ```bash
   echo "facebook.com" | ./submapper.sh
   ```
   - Note: This assumes the script is modified to read input from stdin (optional enhancement).

3. **Check results after running:**
   ```bash
   cat facebook.com/all_subdomains.txt
   ```
   - Displays the list of unique subdomains found.

## Notes
- If a tool (e.g., Amass) isn’t installed, that specific source will fail silently, but others will still run.
- Results are stored in `<domain>/all_subdomains.txt`. Intermediate files are cleaned up automatically.

