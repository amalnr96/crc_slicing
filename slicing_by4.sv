`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2023 22:22:38
// Design Name: 
// Module Name: slicing_by4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slicing_by4(
input wire[31:0] data_i, 
input wire[31:0] old_crc_i, 
output wire crc_valid, 
output reg [31:0] new_crc_o

    );
 logic [31:0] mycrc32table0[256]= {32'h00000000,32'h77073096,32'hee0e612c,32'h990951ba,32'h076dc419,32'h706af48f,32'he963a535,32'h9e6495a3,
                               32'h0edb8832,32'h79dcb8a4,32'he0d5e91e,32'h97d2d988,32'h09b64c2b,32'h7eb17cbd,32'he7b82d07,32'h90bf1d91,
                               32'h1db71064,32'h6ab020f2,32'hf3b97148,32'h84be41de,32'h1adad47d,32'h6ddde4eb,32'hf4d4b551,32'h83d385c7,
                               32'h136c9856,32'h646ba8c0,32'hfd62f97a,32'h8a65c9ec,32'h14015c4f,32'h63066cd9,32'hfa0f3d63,32'h8d080df5,
                               32'h3b6e20c8,32'h4c69105e,32'hd56041e4,32'ha2677172,32'h3c03e4d1,32'h4b04d447,32'hd20d85fd,32'ha50ab56b,
                               32'h35b5a8fa,32'h42b2986c,32'hdbbbc9d6,32'hacbcf940,32'h32d86ce3,32'h45df5c75,32'hdcd60dcf,32'habd13d59,
                               32'h26d930ac,32'h51de003a,32'hc8d75180,32'hbfd06116,32'h21b4f4b5,32'h56b3c423,32'hcfba9599,32'hb8bda50f,
                               32'h2802b89e,32'h5f058808,32'hc60cd9b2,32'hb10be924,32'h2f6f7c87,32'h58684c11,32'hc1611dab,32'hb6662d3d,
                               32'h76dc4190,32'h01db7106,32'h98d220bc,32'hefd5102a,32'h71b18589,32'h06b6b51f,32'h9fbfe4a5,32'he8b8d433,
                               32'h7807c9a2,32'h0f00f934,32'h9609a88e,32'he10e9818,32'h7f6a0dbb,32'h086d3d2d,32'h91646c97,32'he6635c01,
                               32'h6b6b51f4,32'h1c6c6162,32'h856530d8,32'hf262004e,32'h6c0695ed,32'h1b01a57b,32'h8208f4c1,32'hf50fc457,
                               32'h65b0d9c6,32'h12b7e950,32'h8bbeb8ea,32'hfcb9887c,32'h62dd1ddf,32'h15da2d49,32'h8cd37cf3,32'hfbd44c65,
                               32'h4db26158,32'h3ab551ce,32'ha3bc0074,32'hd4bb30e2,32'h4adfa541,32'h3dd895d7,32'ha4d1c46d,32'hd3d6f4fb,
                               32'h4369e96a,32'h346ed9fc,32'had678846,32'hda60b8d0,32'h44042d73,32'h33031de5,32'haa0a4c5f,32'hdd0d7cc9,
                               32'h5005713c,32'h270241aa,32'hbe0b1010,32'hc90c2086,32'h5768b525,32'h206f85b3,32'hb966d409,32'hce61e49f,
                               32'h5edef90e,32'h29d9c998,32'hb0d09822,32'hc7d7a8b4,32'h59b33d17,32'h2eb40d81,32'hb7bd5c3b,32'hc0ba6cad,
                               32'hedb88320,32'h9abfb3b6,32'h03b6e20c,32'h74b1d29a,32'head54739,32'h9dd277af,32'h04db2615,32'h73dc1683,
                               32'he3630b12,32'h94643b84,32'h0d6d6a3e,32'h7a6a5aa8,32'he40ecf0b,32'h9309ff9d,32'h0a00ae27,32'h7d079eb1,
                               32'hf00f9344,32'h8708a3d2,32'h1e01f268,32'h6906c2fe,32'hf762575d,32'h806567cb,32'h196c3671,32'h6e6b06e7,
                               32'hfed41b76,32'h89d32be0,32'h10da7a5a,32'h67dd4acc,32'hf9b9df6f,32'h8ebeeff9,32'h17b7be43,32'h60b08ed5,
                               32'hd6d6a3e8,32'ha1d1937e,32'h38d8c2c4,32'h4fdff252,32'hd1bb67f1,32'ha6bc5767,32'h3fb506dd,32'h48b2364b,
                               32'hd80d2bda,32'haf0a1b4c,32'h36034af6,32'h41047a60,32'hdf60efc3,32'ha867df55,32'h316e8eef,32'h4669be79,
                               32'hcb61b38c,32'hbc66831a,32'h256fd2a0,32'h5268e236,32'hcc0c7795,32'hbb0b4703,32'h220216b9,32'h5505262f,
                               32'hc5ba3bbe,32'hb2bd0b28,32'h2bb45a92,32'h5cb36a04,32'hc2d7ffa7,32'hb5d0cf31,32'h2cd99e8b,32'h5bdeae1d,
                               32'h9b64c2b0,32'hec63f226,32'h756aa39c,32'h026d930a,32'h9c0906a9,32'heb0e363f,32'h72076785,32'h05005713,
                               32'h95bf4a82,32'he2b87a14,32'h7bb12bae,32'h0cb61b38,32'h92d28e9b,32'he5d5be0d,32'h7cdcefb7,32'h0bdbdf21,
                               32'h86d3d2d4,32'hf1d4e242,32'h68ddb3f8,32'h1fda836e,32'h81be16cd,32'hf6b9265b,32'h6fb077e1,32'h18b74777,
                               32'h88085ae6,32'hff0f6a70,32'h66063bca,32'h11010b5c,32'h8f659eff,32'hf862ae69,32'h616bffd3,32'h166ccf45,
                               32'ha00ae278,32'hd70dd2ee,32'h4e048354,32'h3903b3c2,32'ha7672661,32'hd06016f7,32'h4969474d,32'h3e6e77db,
                               32'haed16a4a,32'hd9d65adc,32'h40df0b66,32'h37d83bf0,32'ha9bcae53,32'hdebb9ec5,32'h47b2cf7f,32'h30b5ffe9,
                               32'hbdbdf21c,32'hcabac28a,32'h53b39330,32'h24b4a3a6,32'hbad03605,32'hcdd70693,32'h54de5729,32'h23d967bf,
                               32'hb3667a2e,32'hc4614ab8,32'h5d681b02,32'h2a6f2b94,32'hb40bbe37,32'hc30c8ea1,32'h5a05df1b,32'h2D02EF8D};

 logic [31:0] mycrc32table1[256]= { 32'h00000000,32'h191B3141,32'h32366282,32'h2B2D53C3,32'h646CC504,32'h7D77F445,32'h565AA786,32'h4F4196C7,
    32'hC8D98A08,32'hD1C2BB49,32'hFAEFE88A,32'hE3F4D9CB,32'hACB54F0C,32'hB5AE7E4D,32'h9E832D8E,32'h87981CCF,
    32'h4AC21251,32'h53D92310,32'h78F470D3,32'h61EF4192,32'h2EAED755,32'h37B5E614,32'h1C98B5D7,32'h05838496,
    32'h821B9859,32'h9B00A918,32'hB02DFADB,32'hA936CB9A,32'hE6775D5D,32'hFF6C6C1C,32'hD4413FDF,32'hCD5A0E9E,
    32'h958424A2,32'h8C9F15E3,32'hA7B24620,32'hBEA97761,32'hF1E8E1A6,32'hE8F3D0E7,32'hC3DE8324,32'hDAC5B265,
    32'h5D5DAEAA,32'h44469FEB,32'h6F6BCC28,32'h7670FD69,32'h39316BAE,32'h202A5AEF,32'h0B07092C,32'h121C386D,
    32'hDF4636F3,32'hC65D07B2,32'hED705471,32'hF46B6530,32'hBB2AF3F7,32'hA231C2B6,32'h891C9175,32'h9007A034,
    32'h179FBCFB,32'h0E848DBA,32'h25A9DE79,32'h3CB2EF38,32'h73F379FF,32'h6AE848BE,32'h41C51B7D,32'h58DE2A3C,
    32'hF0794F05,32'hE9627E44,32'hC24F2D87,32'hDB541CC6,32'h94158A01,32'h8D0EBB40,32'hA623E883,32'hBF38D9C2,
    32'h38A0C50D,32'h21BBF44C,32'h0A96A78F,32'h138D96CE,32'h5CCC0009,32'h45D73148,32'h6EFA628B,32'h77E153CA,
    32'hBABB5D54,32'hA3A06C15,32'h888D3FD6,32'h91960E97,32'hDED79850,32'hC7CCA911,32'hECE1FAD2,32'hF5FACB93,
    32'h7262D75C,32'h6B79E61D,32'h4054B5DE,32'h594F849F,32'h160E1258,32'h0F152319,32'h243870DA,32'h3D23419B,
    32'h65FD6BA7,32'h7CE65AE6,32'h57CB0925,32'h4ED03864,32'h0191AEA3,32'h188A9FE2,32'h33A7CC21,32'h2ABCFD60,
    32'hAD24E1AF,32'hB43FD0EE,32'h9F12832D,32'h8609B26C,32'hC94824AB,32'hD05315EA,32'hFB7E4629,32'hE2657768,
    32'h2F3F79F6,32'h362448B7,32'h1D091B74,32'h04122A35,32'h4B53BCF2,32'h52488DB3,32'h7965DE70,32'h607EEF31,
    32'hE7E6F3FE,32'hFEFDC2BF,32'hD5D0917C,32'hCCCBA03D,32'h838A36FA,32'h9A9107BB,32'hB1BC5478,32'hA8A76539,
    32'h3B83984B,32'h2298A90A,32'h09B5FAC9,32'h10AECB88,32'h5FEF5D4F,32'h46F46C0E,32'h6DD93FCD,32'h74C20E8C,
    32'hF35A1243,32'hEA412302,32'hC16C70C1,32'hD8774180,32'h9736D747,32'h8E2DE606,32'hA500B5C5,32'hBC1B8484,
    32'h71418A1A,32'h685ABB5B,32'h4377E898,32'h5A6CD9D9,32'h152D4F1E,32'h0C367E5F,32'h271B2D9C,32'h3E001CDD,
    32'hB9980012,32'hA0833153,32'h8BAE6290,32'h92B553D1,32'hDDF4C516,32'hC4EFF457,32'hEFC2A794,32'hF6D996D5,
    32'hAE07BCE9,32'hB71C8DA8,32'h9C31DE6B,32'h852AEF2A,32'hCA6B79ED,32'hD37048AC,32'hF85D1B6F,32'hE1462A2E,
    32'h66DE36E1,32'h7FC507A0,32'h54E85463,32'h4DF36522,32'h02B2F3E5,32'h1BA9C2A4,32'h30849167,32'h299FA026,
    32'hE4C5AEB8,32'hFDDE9FF9,32'hD6F3CC3A,32'hCFE8FD7B,32'h80A96BBC,32'h99B25AFD,32'hB29F093E,32'hAB84387F,
    32'h2C1C24B0,32'h350715F1,32'h1E2A4632,32'h07317773,32'h4870E1B4,32'h516BD0F5,32'h7A468336,32'h635DB277,
    32'hCBFAD74E,32'hD2E1E60F,32'hF9CCB5CC,32'hE0D7848D,32'hAF96124A,32'hB68D230B,32'h9DA070C8,32'h84BB4189,
    32'h03235D46,32'h1A386C07,32'h31153FC4,32'h280E0E85,32'h674F9842,32'h7E54A903,32'h5579FAC0,32'h4C62CB81,
    32'h8138C51F,32'h9823F45E,32'hB30EA79D,32'hAA1596DC,32'hE554001B,32'hFC4F315A,32'hD7626299,32'hCE7953D8,
    32'h49E14F17,32'h50FA7E56,32'h7BD72D95,32'h62CC1CD4,32'h2D8D8A13,32'h3496BB52,32'h1FBBE891,32'h06A0D9D0,
    32'h5E7EF3EC,32'h4765C2AD,32'h6C48916E,32'h7553A02F,32'h3A1236E8,32'h230907A9,32'h0824546A,32'h113F652B,
    32'h96A779E4,32'h8FBC48A5,32'hA4911B66,32'hBD8A2A27,32'hF2CBBCE0,32'hEBD08DA1,32'hC0FDDE62,32'hD9E6EF23,
    32'h14BCE1BD,32'h0DA7D0FC,32'h268A833F,32'h3F91B27E,32'h70D024B9,32'h69CB15F8,32'h42E6463B,32'h5BFD777A,
    32'hDC656BB5,32'hC57E5AF4,32'hEE530937,32'hF7483876,32'hB809AEB1,32'hA1129FF0,32'h8A3FCC33,32'h9324FD72};

 logic [31:0] mycrc32table2[256]= {32'h00000000,32'h01C26A37,32'h0384D46E,32'h0246BE59,32'h0709A8DC,32'h06CBC2EB,32'h048D7CB2,32'h054F1685,
    32'h0E1351B8,32'h0FD13B8F,32'h0D9785D6,32'h0C55EFE1,32'h091AF964,32'h08D89353,32'h0A9E2D0A,32'h0B5C473D,
    32'h1C26A370,32'h1DE4C947,32'h1FA2771E,32'h1E601D29,32'h1B2F0BAC,32'h1AED619B,32'h18ABDFC2,32'h1969B5F5,
    32'h1235F2C8,32'h13F798FF,32'h11B126A6,32'h10734C91,32'h153C5A14,32'h14FE3023,32'h16B88E7A,32'h177AE44D,
    32'h384D46E0,32'h398F2CD7,32'h3BC9928E,32'h3A0BF8B9,32'h3F44EE3C,32'h3E86840B,32'h3CC03A52,32'h3D025065,
    32'h365E1758,32'h379C7D6F,32'h35DAC336,32'h3418A901,32'h3157BF84,32'h3095D5B3,32'h32D36BEA,32'h331101DD,
    32'h246BE590,32'h25A98FA7,32'h27EF31FE,32'h262D5BC9,32'h23624D4C,32'h22A0277B,32'h20E69922,32'h2124F315,
    32'h2A78B428,32'h2BBADE1F,32'h29FC6046,32'h283E0A71,32'h2D711CF4,32'h2CB376C3,32'h2EF5C89A,32'h2F37A2AD,
    32'h709A8DC0,32'h7158E7F7,32'h731E59AE,32'h72DC3399,32'h7793251C,32'h76514F2B,32'h7417F172,32'h75D59B45,
    32'h7E89DC78,32'h7F4BB64F,32'h7D0D0816,32'h7CCF6221,32'h798074A4,32'h78421E93,32'h7A04A0CA,32'h7BC6CAFD,
    32'h6CBC2EB0,32'h6D7E4487,32'h6F38FADE,32'h6EFA90E9,32'h6BB5866C,32'h6A77EC5B,32'h68315202,32'h69F33835,
    32'h62AF7F08,32'h636D153F,32'h612BAB66,32'h60E9C151,32'h65A6D7D4,32'h6464BDE3,32'h662203BA,32'h67E0698D,
    32'h48D7CB20,32'h4915A117,32'h4B531F4E,32'h4A917579,32'h4FDE63FC,32'h4E1C09CB,32'h4C5AB792,32'h4D98DDA5,
    32'h46C49A98,32'h4706F0AF,32'h45404EF6,32'h448224C1,32'h41CD3244,32'h400F5873,32'h4249E62A,32'h438B8C1D,
    32'h54F16850,32'h55330267,32'h5775BC3E,32'h56B7D609,32'h53F8C08C,32'h523AAABB,32'h507C14E2,32'h51BE7ED5,
    32'h5AE239E8,32'h5B2053DF,32'h5966ED86,32'h58A487B1,32'h5DEB9134,32'h5C29FB03,32'h5E6F455A,32'h5FAD2F6D,
    32'hE1351B80,32'hE0F771B7,32'hE2B1CFEE,32'hE373A5D9,32'hE63CB35C,32'hE7FED96B,32'hE5B86732,32'hE47A0D05,
    32'hEF264A38,32'hEEE4200F,32'hECA29E56,32'hED60F461,32'hE82FE2E4,32'hE9ED88D3,32'hEBAB368A,32'hEA695CBD,
    32'hFD13B8F0,32'hFCD1D2C7,32'hFE976C9E,32'hFF5506A9,32'hFA1A102C,32'hFBD87A1B,32'hF99EC442,32'hF85CAE75,
    32'hF300E948,32'hF2C2837F,32'hF0843D26,32'hF1465711,32'hF4094194,32'hF5CB2BA3,32'hF78D95FA,32'hF64FFFCD,
    32'hD9785D60,32'hD8BA3757,32'hDAFC890E,32'hDB3EE339,32'hDE71F5BC,32'hDFB39F8B,32'hDDF521D2,32'hDC374BE5,
    32'hD76B0CD8,32'hD6A966EF,32'hD4EFD8B6,32'hD52DB281,32'hD062A404,32'hD1A0CE33,32'hD3E6706A,32'hD2241A5D,
    32'hC55EFE10,32'hC49C9427,32'hC6DA2A7E,32'hC7184049,32'hC25756CC,32'hC3953CFB,32'hC1D382A2,32'hC011E895,
    32'hCB4DAFA8,32'hCA8FC59F,32'hC8C97BC6,32'hC90B11F1,32'hCC440774,32'hCD866D43,32'hCFC0D31A,32'hCE02B92D,
    32'h91AF9640,32'h906DFC77,32'h922B422E,32'h93E92819,32'h96A63E9C,32'h976454AB,32'h9522EAF2,32'h94E080C5,
    32'h9FBCC7F8,32'h9E7EADCF,32'h9C381396,32'h9DFA79A1,32'h98B56F24,32'h99770513,32'h9B31BB4A,32'h9AF3D17D,
    32'h8D893530,32'h8C4B5F07,32'h8E0DE15E,32'h8FCF8B69,32'h8A809DEC,32'h8B42F7DB,32'h89044982,32'h88C623B5,
    32'h839A6488,32'h82580EBF,32'h801EB0E6,32'h81DCDAD1,32'h8493CC54,32'h8551A663,32'h8717183A,32'h86D5720D,
    32'hA9E2D0A0,32'hA820BA97,32'hAA6604CE,32'hABA46EF9,32'hAEEB787C,32'hAF29124B,32'hAD6FAC12,32'hACADC625,
    32'hA7F18118,32'hA633EB2F,32'hA4755576,32'hA5B73F41,32'hA0F829C4,32'hA13A43F3,32'hA37CFDAA,32'hA2BE979D,
    32'hB5C473D0,32'hB40619E7,32'hB640A7BE,32'hB782CD89,32'hB2CDDB0C,32'hB30FB13B,32'hB1490F62,32'hB08B6555,
    32'hBBD72268,32'hBA15485F,32'hB853F606,32'hB9919C31,32'hBCDE8AB4,32'hBD1CE083,32'hBF5A5EDA,32'hBE9834ED};

 logic [31:0] mycrc32table3[256]= {32'h00000000,32'hB8BC6765,32'hAA09C88B,32'h12B5AFEE,32'h8F629757,32'h37DEF032,32'h256B5FDC,32'h9DD738B9,
    32'hC5B428EF,32'h7D084F8A,32'h6FBDE064,32'hD7018701,32'h4AD6BFB8,32'hF26AD8DD,32'hE0DF7733,32'h58631056,
    32'h5019579F,32'hE8A530FA,32'hFA109F14,32'h42ACF871,32'hDF7BC0C8,32'h67C7A7AD,32'h75720843,32'hCDCE6F26,
    32'h95AD7F70,32'h2D111815,32'h3FA4B7FB,32'h8718D09E,32'h1ACFE827,32'hA2738F42,32'hB0C620AC,32'h087A47C9,
    32'hA032AF3E,32'h188EC85B,32'h0A3B67B5,32'hB28700D0,32'h2F503869,32'h97EC5F0C,32'h8559F0E2,32'h3DE59787,
    32'h658687D1,32'hDD3AE0B4,32'hCF8F4F5A,32'h7733283F,32'hEAE41086,32'h525877E3,32'h40EDD80D,32'hF851BF68,
    32'hF02BF8A1,32'h48979FC4,32'h5A22302A,32'hE29E574F,32'h7F496FF6,32'hC7F50893,32'hD540A77D,32'h6DFCC018,
    32'h359FD04E,32'h8D23B72B,32'h9F9618C5,32'h272A7FA0,32'hBAFD4719,32'h0241207C,32'h10F48F92,32'hA848E8F7,
    32'h9B14583D,32'h23A83F58,32'h311D90B6,32'h89A1F7D3,32'h1476CF6A,32'hACCAA80F,32'hBE7F07E1,32'h06C36084,
    32'h5EA070D2,32'hE61C17B7,32'hF4A9B859,32'h4C15DF3C,32'hD1C2E785,32'h697E80E0,32'h7BCB2F0E,32'hC377486B,
    32'hCB0D0FA2,32'h73B168C7,32'h6104C729,32'hD9B8A04C,32'h446F98F5,32'hFCD3FF90,32'hEE66507E,32'h56DA371B,
    32'h0EB9274D,32'hB6054028,32'hA4B0EFC6,32'h1C0C88A3,32'h81DBB01A,32'h3967D77F,32'h2BD27891,32'h936E1FF4,
    32'h3B26F703,32'h839A9066,32'h912F3F88,32'h299358ED,32'hB4446054,32'h0CF80731,32'h1E4DA8DF,32'hA6F1CFBA,
    32'hFE92DFEC,32'h462EB889,32'h549B1767,32'hEC277002,32'h71F048BB,32'hC94C2FDE,32'hDBF98030,32'h6345E755,
    32'h6B3FA09C,32'hD383C7F9,32'hC1366817,32'h798A0F72,32'hE45D37CB,32'h5CE150AE,32'h4E54FF40,32'hF6E89825,
    32'hAE8B8873,32'h1637EF16,32'h048240F8,32'hBC3E279D,32'h21E91F24,32'h99557841,32'h8BE0D7AF,32'h335CB0CA,
    32'hED59B63B,32'h55E5D15E,32'h47507EB0,32'hFFEC19D5,32'h623B216C,32'hDA874609,32'hC832E9E7,32'h708E8E82,
    32'h28ED9ED4,32'h9051F9B1,32'h82E4565F,32'h3A58313A,32'hA78F0983,32'h1F336EE6,32'h0D86C108,32'hB53AA66D,
    32'hBD40E1A4,32'h05FC86C1,32'h1749292F,32'hAFF54E4A,32'h322276F3,32'h8A9E1196,32'h982BBE78,32'h2097D91D,
    32'h78F4C94B,32'hC048AE2E,32'hD2FD01C0,32'h6A4166A5,32'hF7965E1C,32'h4F2A3979,32'h5D9F9697,32'hE523F1F2,
    32'h4D6B1905,32'hF5D77E60,32'hE762D18E,32'h5FDEB6EB,32'hC2098E52,32'h7AB5E937,32'h680046D9,32'hD0BC21BC,
    32'h88DF31EA,32'h3063568F,32'h22D6F961,32'h9A6A9E04,32'h07BDA6BD,32'hBF01C1D8,32'hADB46E36,32'h15080953,
    32'h1D724E9A,32'hA5CE29FF,32'hB77B8611,32'h0FC7E174,32'h9210D9CD,32'h2AACBEA8,32'h38191146,32'h80A57623,
    32'hD8C66675,32'h607A0110,32'h72CFAEFE,32'hCA73C99B,32'h57A4F122,32'hEF189647,32'hFDAD39A9,32'h45115ECC,
    32'h764DEE06,32'hCEF18963,32'hDC44268D,32'h64F841E8,32'hF92F7951,32'h41931E34,32'h5326B1DA,32'hEB9AD6BF,
    32'hB3F9C6E9,32'h0B45A18C,32'h19F00E62,32'hA14C6907,32'h3C9B51BE,32'h842736DB,32'h96929935,32'h2E2EFE50,
    32'h2654B999,32'h9EE8DEFC,32'h8C5D7112,32'h34E11677,32'hA9362ECE,32'h118A49AB,32'h033FE645,32'hBB838120,
    32'hE3E09176,32'h5B5CF613,32'h49E959FD,32'hF1553E98,32'h6C820621,32'hD43E6144,32'hC68BCEAA,32'h7E37A9CF,
    32'hD67F4138,32'h6EC3265D,32'h7C7689B3,32'hC4CAEED6,32'h591DD66F,32'hE1A1B10A,32'hF3141EE4,32'h4BA87981,
    32'h13CB69D7,32'hAB770EB2,32'hB9C2A15C,32'h017EC639,32'h9CA9FE80,32'h241599E5,32'h36A0360B,32'h8E1C516E,
    32'h866616A7,32'h3EDA71C2,32'h2C6FDE2C,32'h94D3B949,32'h090481F0,32'hB1B8E695,32'hA30D497B,32'h1BB12E1E,
    32'h43D23E48,32'hFB6E592D,32'hE9DBF6C3,32'h516791A6,32'hCCB0A91F,32'h740CCE7A,32'h66B96194,32'hDE0506F1};
    
    logic  [31:0]crc_d[6:0];
    logic  [31:0]crc_q;
    logic  [31:0]my_crc;
    
    always_comb begin
    crc_d[0]  = ~old_crc_i;
    crc_d[1]  = crc_d[0]^ data_i; 
    crc_d[2]  = mycrc32table3[crc_d[1][7:0]];
    crc_d[3]  = mycrc32table2[crc_d[1][15:8]];
    crc_d[4]  = mycrc32table1[crc_d[1][23:16]];
    crc_d[5]  = mycrc32table0[crc_d[1][31:24]];
    crc_d [6] = crc_d[2]^crc_d[3]^ crc_d[4]^crc_d[5];
    end       
    
    assign new_crc_o = ~crc_d[6];
    assign crc_valid = |(crc_d[6]);
endmodule









