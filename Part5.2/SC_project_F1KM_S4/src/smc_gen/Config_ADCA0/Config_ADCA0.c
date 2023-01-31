/***********************************************************************************************************************
* DISCLAIMER
* This software is supplied by Renesas Electronics Corporation and is only intended for use with Renesas products.
* No other uses are authorized. This software is owned by Renesas Electronics Corporation and is protected under all
* applicable laws, including copyright laws. 
* THIS SOFTWARE IS PROVIDED "AS IS" AND RENESAS MAKES NO WARRANTIES REGARDING THIS SOFTWARE, WHETHER EXPRESS, IMPLIED
* OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NON-INFRINGEMENT.  ALL SUCH WARRANTIES ARE EXPRESSLY DISCLAIMED.TO THE MAXIMUM EXTENT PERMITTED NOT PROHIBITED BY
* LAW, NEITHER RENESAS ELECTRONICS CORPORATION NOR ANY OF ITS AFFILIATED COMPANIES SHALL BE LIABLE FOR ANY DIRECT,
* INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES FOR ANY REASON RELATED TO THIS SOFTWARE, EVEN IF RENESAS OR
* ITS AFFILIATES HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
* Renesas reserves the right, without notice, to make changes to this software and to discontinue the availability 
* of this software. By using this software, you agree to the additional terms and conditions found by accessing the 
* following link:
* http://www.renesas.com/disclaimer
*
* Copyright (C) 2019 Renesas Electronics Corporation. All rights reserved.
***********************************************************************************************************************/

/***********************************************************************************************************************
* File Name    : Config_ADCA0.c
* Version      : 1.1.102
* Device(s)    : R7F701650
* Description  : This file implements device driver for Config_ADCA0.
***********************************************************************************************************************/
/***********************************************************************************************************************
Pragma directive
***********************************************************************************************************************/
/* Start user code for pragma. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */

/***********************************************************************************************************************
Includes
***********************************************************************************************************************/
#include "r_cg_macrodriver.h"
#include "r_cg_userdefine.h"
#include "Config_ADCA0.h"
/* Start user code for include. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */

/***********************************************************************************************************************
Global variables and functions
***********************************************************************************************************************/
extern volatile uint32_t g_cg_sync_read;
/* Start user code for global. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */

/***********************************************************************************************************************
* Function Name: R_Config_ADCA0_Create
* Description  : This function initializes the ADC module
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void R_Config_ADCA0_Create(void)
{
    /* Disable ADC0 error interrupt (INTADCA0ERR) operation and clear request */
    INTC2.ICADCA0ERR.BIT.MKADCA0ERR = _INT_PROCESSING_DISABLED;
    INTC2.ICADCA0ERR.BIT.RFADCA0ERR = _INT_REQUEST_NOT_OCCUR;
    /* Disable ADC0 SG1 end interrupt (INTADCA0I0) operation and clear request */
    INTC1.ICADCA0I0.BIT.MKADCA0I0 = _INT_PROCESSING_DISABLED;
    INTC1.ICADCA0I0.BIT.RFADCA0I0 = _INT_REQUEST_NOT_OCCUR;
    /* Disable ADC0 SG2 end interrupt (INTADCA0I1) operation and clear request */
    INTC1.ICADCA0I1.BIT.MKADCA0I1 = _INT_PROCESSING_DISABLED;
    INTC1.ICADCA0I1.BIT.RFADCA0I1 = _INT_REQUEST_NOT_OCCUR;
    /* Disable ADC0 SG3 end interrupt (INTADCA0I2) operation and clear request */
    INTC1.ICADCA0I2.BIT.MKADCA0I2 = _INT_PROCESSING_DISABLED;
    INTC1.ICADCA0I2.BIT.RFADCA0I2 = _INT_REQUEST_NOT_OCCUR;
    /* Set ADC0 error interrupt (INTADCA0ERR) setting */
    INTC2.ICADCA0ERR.BIT.TBADCA0ERR = _INT_TABLE_VECTOR;
    INTC2.ICADCA0ERR.UINT16 &= _INT_PRIORITY_LOWEST;
    /* Set ADC0 SG1 end interrupt (INTADCA0I0) setting */
    INTC1.ICADCA0I0.BIT.TBADCA0I0 = _INT_TABLE_VECTOR;
    INTC1.ICADCA0I0.UINT16 &= _INT_PRIORITY_LOWEST;
    /* Set ADC0 global setting */
    ADCA0.ADCR.UINT32 = _ADC_12_BIT_MODE;
    ADCA0.SMPCR.UINT32 = _ADC_18_CYCLES;
    ADCA0.SFTCR.UINT32 = _ADC_READ_CLEAR_DISABLED | _ADC_LIMIT_ERROR_INT_ENABLE | _ADC_OVERWRITE_ERROR_INT_ENABLE;
    ADCA0.ULLMTBR0.UINT32 = _ADC0_UPPER_LIMIT_TABLE0 | _ADC0_LOWER_LIMIT_TABLE0;
    ADCA0.ULLMTBR1.UINT32 = _ADC0_UPPER_LIMIT_TABLE1 | _ADC0_LOWER_LIMIT_TABLE1;
    ADCA0.ULLMTBR2.UINT32 = _ADC0_UPPER_LIMIT_TABLE2 | _ADC0_LOWER_LIMIT_TABLE2;
    ADCA0.ULLMTBR3.UINT32 = _ADC0_UPPER_LIMIT_TABLE3 | _ADC0_LOWER_LIMIT_TABLE3;
    ADCA0.ULLMTBR4.UINT32 = _ADC0_UPPER_LIMIT_TABLE4 | _ADC0_LOWER_LIMIT_TABLE4;
    ADCA0.ULLMTBR5.UINT32 = _ADC0_UPPER_LIMIT_TABLE5 | _ADC0_LOWER_LIMIT_TABLE5;
    ADCA0.ULLMTBR6.UINT32 = _ADC0_UPPER_LIMIT_TABLE6 | _ADC0_LOWER_LIMIT_TABLE6;
    ADCA0.ULLMTBR7.UINT32 = _ADC0_UPPER_LIMIT_TABLE7 | _ADC0_LOWER_LIMIT_TABLE7;
    /* Set ADC0 scan group setting */
    ADCA0.SGVCSP1.UINT32 = _ADC0_SG1_START_POINTER;
    ADCA0.SGVCEP1.UINT32 = _ADC0_SG1_END_POINTER;
    ADCA0.SGMCYCR1.UINT32 = _ADC_SG_MULTICYCLE_NUMBER_1;
    ADCA0.SGCR1.UINT32 = _ADC_SG_SCAN_MODE_MULTICYCLE | _ADC_SG_SCAN_END_INT_ENABLE | _ADC_SG_HW_TRIGGER_DISABLE;
    ADCA0.VCR00.UINT32 = _ADC_VIRTUAL_CHANNEL_END_INT_ENABLE | _ADC_LIMIT_TABLE_SELECT_NONE | _ADC_PHYSICAL_CHANNEL_AN09;
    ADCA0.VCR01.UINT32 = _ADC_VIRTUAL_CHANNEL_END_INT_ENABLE | _ADC_LIMIT_TABLE_SELECT_NONE | _ADC_PHYSICAL_CHANNEL_AN04;
    ADCA0.VCR02.UINT32 = _ADC_VIRTUAL_CHANNEL_END_INT_ENABLE | _ADC_LIMIT_TABLE_SELECT_NONE | _ADC_PHYSICAL_CHANNEL_AN06;
    /* Set T&H setting */
    ADCA0.THCR.UINT32 = _ADC_TH_SAMPLING_MANUAL;
    ADCA0.THER.UINT32 = _ADC_TH5_DISABLED | _ADC_TH4_DISABLED | _ADC_TH3_DISABLED | _ADC_TH2_DISABLED | 
                        _ADC_TH1_DISABLED | _ADC_TH0_DISABLED;
    /* Synchronization processing */
    g_cg_sync_read = ADCA0.ADHALTR.UINT32;
    __syncp();
    /* Clear ADC0 error interrupt (INTADCA0ERR) request and enable operation */
    INTC2.ICADCA0ERR.BIT.RFADCA0ERR = _INT_REQUEST_NOT_OCCUR;
    INTC2.ICADCA0ERR.BIT.MKADCA0ERR = _INT_PROCESSING_ENABLED;

    R_Config_ADCA0_Create_UserInit();
}

/***********************************************************************************************************************
* Function Name: R_Config_ADCA0_Halt
* Description  : This function halts ADC0
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void R_Config_ADCA0_Halt(void)
{
    ADCA0.ADHALTR.UINT32 = _ADC_HALT;
    /* Synchronization processing */
    g_cg_sync_read = ADCA0.ADHALTR.UINT32;
    __syncp();
}

/***********************************************************************************************************************
* Function Name: R_Config_ADCA0_ScanGroup1_Start
* Description  : This function enables ADC0 scan group 1 end interrupt.
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void R_Config_ADCA0_ScanGroup1_Start(void)
{
    /* Clear ADC0 SG1 end interrupt (INTADCA0I0) request and enable operation */
    INTC1.ICADCA0I0.BIT.RFADCA0I0 = _INT_REQUEST_NOT_OCCUR;
    INTC1.ICADCA0I0.BIT.MKADCA0I0 = _INT_PROCESSING_ENABLED;
}

/***********************************************************************************************************************
* Function Name: R_Config_ADCA0_ScanGroup1_OperationOn
* Description  : This function starts ADC0 scan group 1 convertion.
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void R_Config_ADCA0_ScanGroup1_OperationOn(void)
{
    /* Enable ADC0 SG1 operation */
    ADCA0.SGSTCR1.UINT32 = _ADC_START;
}

/***********************************************************************************************************************
* Function Name: R_Config_ADCA0_ScanGroup1_GetResult
* Description  : This function gets A/D conversion result for ADC0 scan group 1.
* Arguments    : buffer -
*                    result value
* Return Value : None
***********************************************************************************************************************/
void R_Config_ADCA0_ScanGroup1_GetResult(uint16_t * const buffer)
{
    uint8_t count_num, count;
    uint32_t *addr;
    uint32_t convert_data;

    count_num = ADCA0.SGVCEP1.UINT32;
    count_num = count_num - ADCA0.SGVCSP1.UINT32 + 1U;
    addr = (uint32_t*)(_ADC0_VCHANNEL_DATA_BASE + (2 * ADCA0.SGVCSP1.UINT32));

    for (count = 0; count < count_num; count = count + 2)
    {
        convert_data = (uint32_t)*addr;
        buffer[count] = (uint16_t)(convert_data & 0x0000FFFF);
        if ( count_num - count > 1 )
        {
            buffer[count + 1] = (uint16_t)((convert_data & 0xFFFF0000) >> 16);
        }
        addr++;
    }
}

/* Start user code for adding. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */
