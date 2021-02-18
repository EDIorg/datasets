These data contain more than one missing value code per column (i.e. NA and ND ("Not detected (Value below the MDL or RL))") and require manual editing of the EML at this time since EMLassemblyline doesn't support use of multiple missing value codes.

Process:
- Remove from data objects
- make_eml()
- Replace checksums of data objects with correct ones
- Add missing value codes and defs to EML