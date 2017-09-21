# Get-Pcap

A powershell function to convert packet capture from FortiGate CLI into pcap format.

Works by converting the captured data to [text2pcap-compatible hexdump](https://www.wireshark.org/docs/man-pages/text2pcap.html), and then using text2pcap to generate the final pcap file.

## Usage

### Setup

- Modify [ExecutionPolicy](https://ss64.com/ps/set-executionpolicy.html) if needed
- Import the module: `Import-Module get-pcap.psm1`

### Use

`Get-Pcap <input file> <output file>`
- Input file is any CLI log containing the packet capture. Non-related lines will be ignored.
- Output file is the resulting file which can be opened in Wireshark.

## Status

- Basic functionality, if text2pcap.exe is found ahd input and output filenames are provide

## To-do

- [ ] More error-catching
- [ ] Compatibility with other CLI outputs (e.g. FortiAuthenticator)
- [ ] Context menu integration