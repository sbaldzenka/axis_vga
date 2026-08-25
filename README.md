# axis_vga

> **version: 1.0**

### Description
VGA IP-core with AXI Video Stream interface.

### Catalog structure:
  - **src** - sources verilog files;
  - **sim** - script files for modelsim/questasim;
  - **tb** - testbenches;

### Parameters table (Pixel Clock = 25 MHz):

| Resolution          | Horizontal parameters | Vertical parameters |
|---------------------|-----------------------|---------------------|
| 640x480@60Hz        | H_ACTIVE  = 640       | V_ACTIVE  = 480     |
|                     | H_F_PORCH = 16        | V_F_PORCH = 11      |
|                     | H_SYNC_P  = 96        | V_SYNC_P  = 2       |
|                     | H_B_PORCH = 48        | V_B_PORCH = 3       |
|---------------------|-----------------------|---------------------|
| 800x600@60Hz        | H_ACTIVE  = 800       | V_ACTIVE  = 600     |
|                     | H_F_PORCH = 40        | V_F_PORCH = 1       |
|                     | H_SYNC_P  = 128       | V_SYNC_P  = 4       |
|                     | H_B_PORCH = 88        | V_B_PORCH = 23      |
|---------------------|-----------------------|---------------------|
| 800x600@72Hz        | H_ACTIVE  = 800       | V_ACTIVE  = 600     |
|                     | H_F_PORCH = 56        | V_F_PORCH = 37      |
|                     | H_SYNC_P  = 120       | V_SYNC_P  = 6       |
|                     | H_B_PORCH = 64        | V_B_PORCH = 2       |
|---------------------|-----------------------|---------------------|
| 800x600@76Hz        | H_ACTIVE  = 800       | V_ACTIVE  = 600     |
|                     | H_F_PORCH = 16        | V_F_PORCH = 1       |
|                     | H_SYNC_P  = 80        | V_SYNC_P  = 2       |
|                     | H_B_PORCH = 160       | V_B_PORCH = 2       |
|---------------------|-----------------------|---------------------|
| 1024x768@70Hz       | H_ACTIVE  = 800       | V_ACTIVE  = 600     |
|                     | H_F_PORCH = 40        | V_F_PORCH = 1       |
|                     | H_SYNC_P  = 128       | V_SYNC_P  = 4       |
|                     | H_B_PORCH = 88        | V_B_PORCH = 2       |