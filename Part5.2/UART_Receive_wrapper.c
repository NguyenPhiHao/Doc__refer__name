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
// ID: ET_VPF_V1.00.00_CD_Req_04_020
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
void UART_Receive_Outputs_wrapper(const real_T *RLIN3nRX,
            real_T *output_rx_data,
            const real_T *RLIN3_unit, const int_T p_width0,
            const real_T *Baudrate, const int_T p_width1)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
//RLIN3n reception
# ifdef ETVPF
    double receive_MATLAB_value = 0; // <=== Data we want to get after UART reception operation.
                                     // Expect = value of variable rlin3nData in ET-VPF Testbench (.py file)
    uint8_t buf[sizeof(double)] = {0};
    unsigned int receive_unit = (unsigned int)RLIN3_unit[0] - 1;   // Input unit from MATLAB
    unsigned int receive_idx = 0;    // Main index: Index value of input unit in functions list of Config_UART_Reception_Receive
    unsigned int idx = 0; // Index value of unit in receive_arr
    int arr_Size = sizeof(receive_arr) / sizeof(* receive_arr); // Length of receive_arr
    while (idx < arr_Size) {
        unsigned int compare_unit = (unsigned int) receive_arr[idx]; // Get unit value in receive_arr
        RLIN3n_reg = arr_RLIN3n[compare_unit];                   // Get RLIN3n according to unit value
        
        // Get main index value if using UART reception & the current unit is input unit
        if ((*(RLIN3n_reg)).LUOER == 0x2 && receive_unit == compare_unit) {
            receive_idx = idx;
            break;
        }
        idx++;
    }
    
    // Get RLIN3n according to input unit value
    RLIN3n_reg = arr_RLIN3n[receive_unit];
    for (uint8_t count = 0; count < 8; ++count) {
        uint8_t flag_val_each_byte_enable_receive = count + 1;
        GMemForSetPortRxControl1 = receive_unit * 100 + flag_val_each_byte_enable_receive;
        // Wait a little
        for (int i = 0; i < 10; i++) {
            // Do nothing
        }
    
        const uint8_t flag_val_make_data_strobe_stop_bit = 9;
        GMemForSetPortRxControl1 = receive_unit * 100 + flag_val_make_data_strobe_stop_bit;
        // Wait a little
        for (int i = 0; i < 10; i++) {
            // Do nothing
        }
    
        const uint8_t flag_val_make_data_strobe_idle = 10;
        GMemForSetPortRxControl1 = receive_unit * 100 + flag_val_make_data_strobe_idle;
        while (((((*(RLIN3n_reg)).LST) >> 5) & 0x1) == 0x1) {
            // Waiting for finishing reception
        }
    
        // 5. Read the data in UART reveive register RLN3nLURDR
        buf[7 - count] = (uint8_t) (*(RLIN3n_reg)).LURDR.UINT16;
        // Get & execute Config_UART_Reception_Receive function
        Config_UART_Reception_Receive(receive_idx, buf, 1);
    }
    
    // 6. Write to receive_MATLAB_value. receive_MATLAB_value now have receive value
    memcpy(&receive_MATLAB_value, buf, sizeof(double));
    
    output_rx_data[0]= (real_T) receive_MATLAB_value;
# else
    // Execute on MATLAB
    output_rx_data[0] = RLIN3nRX[0];
# endif
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


