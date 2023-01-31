/*
 * Copyright(C) 2022 Renesas Electronics Corporation
 * RENESAS ELECTRONICS CONFIDENTIAL AND PROPRIETARY.
 * This program must be used solely for the purpose for which
 * it was furnished by Renesas Electronics Corporation. No part of this
 * program may be reproduced or disclosed to others, in any
 * form, without the prior written permission of Renesas Electronics
 * Corporation.
 */

// ET-VPF F1KM Product Version - V1.00.00 - Req. 04
// ID: ET_VPF_V1.00.00_CD_Req_04_019
// Reference: {ET_VPF_V1.00.00_UD_Req_04_001, ET_VPF_V1.00.00_UD_Req_04_002, ET_VPF_V1.00.00_UD_Req_04_004, ET_VPF_V1.00.00_UD_Req_04_005, ET_VPF_V1.00.00_UD_Req_04_006, ET_VPF_V1.00.00_UD_Req_04_007}

/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif

/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
#include <string.h>
#include "iodefine.h"
#include "r_cg_macrodriver.h"
#include "Test_Environment.h"
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */

/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output functions
 *
 */
void UART_Send_Outputs_wrapper(const real_T *input_tx_data,
            real_T *RLIN3nTX,
            const real_T *RLIN3_unit, const int_T p_width0,
            const real_T *Baudrate, const int_T p_width1)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
//RLIN3n transmission
# ifdef ETVPF
    double val = input_tx_data[0];     // Input data of MATLAB
    long long db = *(long long*)&val;
    unsigned char arr_tx_data[8] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}; // <=== Data we want to get after UART transmission operation. 
                                                                             // Expect = Single-precision floating-point format of variable "val"
    for (int num = 0; num < 8; num++) {
        arr_tx_data[num] = (db >> (num * 8)) & 0xFF;
    }
    
    unsigned int send_unit = (unsigned int)RLIN3_unit[0] - 1; // Input unit from MATLAB
    unsigned int send_idx = 0;  // Main index: Index value of input unit in functions list of Config_UART_Transmission_Send
    unsigned int idx = 0;       // Index value of unit in send_arr
    int arr_Size = sizeof(send_arr) / sizeof(* send_arr); // Length of send_arr
    while (idx < arr_Size) {
        unsigned int compare_unit = (unsigned int) send_arr[idx]; // Get unit value in send_arr
        RLIN3n_reg = arr_RLIN3n[compare_unit];                   // Get RLIN3n according to unit value
        
        // Get main index value if using UART transmission & the current unit is input unit
        if ((*(RLIN3n_reg)).LUOER == 0x1 && send_unit == compare_unit) {
            send_idx = idx;
            break;
        }
        idx++;
    }
    
    RLIN3n_reg = arr_RLIN3n[send_unit]; // Get RLIN3n according to input unit value
    for (int count = 0; count < 8; count++) {
        // Get & execute Config_UART_transmission_Send function
        Config_UART_Transmission_Send(send_idx, &arr_tx_data[count], 1);
        
        while (((((*(RLIN3n_reg)).LST) >> 4) & 0x1) == 0x1) {
            // Waiting for finishing transmission
        }
    }
# else
    // Execute on MATLAB
    RLIN3nTX[0] = input_tx_data[0];
# endif
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


