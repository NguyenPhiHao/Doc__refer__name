/*
 * Copyright(C) 2022 Renesas Electronics Corporation
 * RENESAS ELECTRONICS CONFIDENTIAL AND PROPRIETARY.
 * This program must be used solely for the purpose for which
 * it was furnished by Renesas Electronics Corporation. No part of this
 * program may be reproduced or disclosed to others, in any
 * form, without the prior written permission of Renesas Electronics
 * Corporation.
 */
 
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

#include "iodefine.h"
#include "r_cg_macrodriver.h"
#include "Test_Environment.h"

/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output functions
 *
 */
void get_ADC_data_Outputs_wrapper(const real_T *u0,
            real_T *y0,
            const real_T *unit, const int_T p_width0,
            const real_T *max_vcr_channel, const int_T p_width1,
            const real_T *portID, const int_T p_width2)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
// ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1  for F1KM-S4
// ID: ET_VPF_V1.00.00_CD_Req_ADCUnit1_001 
// Reference: {ET_VPF_V1.00.00_UD_Req_ADCUnit1_001, ET_VPF_V1.00.00_UD_Req_ADCUnit1_004, ET_VPF_V1.00.00_UD_Req_ADCUnit1_007}
# ifdef ETVPF
    // Generated source code
    char unit_ = (char)*unit;
    char max_vcr_channel_ = (char)*max_vcr_channel;
    char portID_ = (char)*portID;

    unsigned int adc_idx = 0;    // Main index: Index value of input unit in functions list of Config_ADC_ScanGroup1_OperationOn, Config_ADC_ScanGroup1_GetResult
    unsigned int idx = 0; // Index value of unit in adc_arr
    int arr_Size = sizeof(adc_arr) / sizeof(* adc_arr); // Length of adc_arr
    while (idx < arr_Size) {
        unsigned int compare_unit = (unsigned int) adc_arr[idx]; // Get unit value in adc_arr
        
        // Get main index value if the current unit is input unit
        if (unit_ == compare_unit) {
            adc_idx = idx;
            break;
        }
        idx++;
    }
    
    Config_ADC_ScanGroup1_OperationOn(adc_idx);
    Wait_For_Conversion(unit_);
   *y0 =  Config_ADC_ScanGroup1_GetResult(adc_idx, unit_, portID_);
    
# else
    // Execute on MATLAB
    y0[0] = u0[0];
# endif
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}
// ET-VPF F1KM Product Version - V1.00.00 - Req. Supporting ADC unit 1 for F1KM-S4 - End

