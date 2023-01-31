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
* File Name    : Config_PORT.c
* Version      : 1.3.0
* Device(s)    : R7F701650
* Description  : This file implements device driver for Config_PORT.
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
#include "Config_PORT.h"
/* Start user code for include. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */

/***********************************************************************************************************************
Global variables and functions
***********************************************************************************************************************/
extern volatile uint32_t g_cg_sync_read;
/* Start user code for global. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */

/***********************************************************************************************************************
* Function Name: R_Config_PORT_Create
* Description  : This function initializes the PORT
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void R_Config_PORT_Create(void)
{
    PORT.PIBC8 = _PORT_PIBC_INIT;
    PORT.PBDC8 = _PORT_PBDC_INIT;
    PORT.PM8 = _PORT_PM_INIT;
    PORT.PMC8 = _PORT_PMC_INIT;
    /* PORT8 setting */
    PORT.PPCMD8 = _WRITE_PROTECT_COMMAND;
    PORT.PODC8 = _PORT_PODCn3_PUSH_PULL | _PORT_PODCn5_PUSH_PULL | _PORT_PODCn6_OPEN_DRAIN;
    PORT.PODC8 = (uint32_t) ~(_PORT_PODCn3_PUSH_PULL | _PORT_PODCn5_PUSH_PULL | _PORT_PODCn6_OPEN_DRAIN);
    PORT.PODC8 = _PORT_PODCn3_PUSH_PULL | _PORT_PODCn5_PUSH_PULL | _PORT_PODCn6_OPEN_DRAIN;
    PORT.PBDC8 = _PORT_PBDCn3_MODE_DISABLED | _PORT_PBDCn5_MODE_DISABLED | _PORT_PBDCn6_MODE_DISABLED;
    PORT.PU8 = _PORT_PUn0_PULLUP_OFF | _PORT_PUn1_PULLUP_OFF | _PORT_PUn2_PULLUP_OFF | _PORT_PUn4_PULLUP_OFF | 
               _PORT_PUn7_PULLUP_OFF | _PORT_PUn8_PULLUP_OFF | _PORT_PUn9_PULLUP_OFF | _PORT_PUn10_PULLUP_OFF | 
               _PORT_PUn11_PULLUP_OFF | _PORT_PUn12_PULLUP_OFF;
    PORT.PD8 = _PORT_PDn0_PULLDOWN_OFF | _PORT_PDn1_PULLDOWN_OFF | _PORT_PDn2_PULLDOWN_OFF | _PORT_PDn4_PULLDOWN_OFF | 
               _PORT_PDn7_PULLDOWN_OFF | _PORT_PDn8_PULLDOWN_OFF | _PORT_PDn9_PULLDOWN_OFF | 
               _PORT_PDn10_PULLDOWN_OFF | _PORT_PDn11_PULLDOWN_OFF | _PORT_PDn12_PULLDOWN_OFF;
    PORT.PIS8 = _PORT_PIS8_DEFAULT_VALUE | _PORT_PISn0_TYPE_SHMT4 | _PORT_PISn1_TYPE_SHMT4 | _PORT_PISn2_TYPE_SHMT4 | 
                _PORT_PISn4_TYPE_SHMT4 | _PORT_PISn7_TYPE_SHMT4 | _PORT_PISn8_TYPE_SHMT4 | _PORT_PISn9_TYPE_SHMT4 | 
                _PORT_PISn10_TYPE_SHMT4 | _PORT_PISn11_TYPE_SHMT4 | _PORT_PISn12_TYPE_SHMT4;
    PORT.P8 = _PORT_Pn3_OUTPUT_LOW | _PORT_Pn5_OUTPUT_LOW | _PORT_Pn6_OUTPUT_LOW;
    PORT.PM8 = _PORT_PM8_DEFAULT_VALUE | _PORT_PMn0_MODE_UNUSED | _PORT_PMn1_MODE_INPUT | _PORT_PMn2_MODE_UNUSED | 
               _PORT_PMn3_MODE_OUTPUT | _PORT_PMn4_MODE_INPUT | _PORT_PMn5_MODE_OUTPUT | _PORT_PMn6_MODE_OUTPUT | 
               _PORT_PMn7_MODE_UNUSED | _PORT_PMn8_MODE_UNUSED | _PORT_PMn9_MODE_UNUSED | _PORT_PMn10_MODE_UNUSED | 
               _PORT_PMn11_MODE_UNUSED | _PORT_PMn12_MODE_UNUSED;
    PORT.PIBC8 = _PORT_PIBCn1_INPUT_BUFFER_ENABLE | _PORT_PIBCn4_INPUT_BUFFER_ENABLE;
    /* Synchronization processing */
    g_cg_sync_read = PORT.PM8;
    __syncp();

    R_Config_PORT_Create_UserInit();
}

/* Start user code for adding. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */
