/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 *
 *
 *
 *
 * ------------------------------------------------
 * | IMPORTANT NOTE: Do NOT run with breakpoints  |
 * | or step-by-step!!! This will cause incorrect |
 * | RX data (probably due to cache flushing).    |
 * | Also make sure linker script limits usage of |
 * | DDR memory for application code.			  |
 * ------------------------------------------------
 *
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xaxidma.h"
#include "xparameters.h"

#define DMA_DEV_ID			XPAR_AXIDMA_0_DEVICE_ID
#define DMA_DATA_GEN_ADDR 	XPAR_RECORD_SUBSYSTEM_AXI_DMA_DATA_GEN_0_S00_AXI_BASEADDR
#define DMA_Buffer_BASEADDR 0x50000000
#define MAX_PKT_LEN			7340032					//7 MiByte

/*
 * Device instance definitions
 */
XAxiDma AxiDma;

int main()
{
    init_platform();

    	u8 *RxBufferPtr = (u8 *)(DMA_Buffer_BASEADDR);
    	u8 Value;
    	XAxiDma_Config *CfgPtr;
    	int Status = 0;

    	// Test DDR access
    	Xil_Out32(RxBufferPtr, 0xAFFED00F);
    	Xil_Out32(RxBufferPtr + MAX_PKT_LEN, 0xDEADBABE);

    	// Stop test data generator
    	*((unsigned*)(DMA_DATA_GEN_ADDR + 0)) = 0;

    	// Initialize the XAxiDma device
    	CfgPtr = XAxiDma_LookupConfig(DMA_DEV_ID);
    	if (!CfgPtr) {
    		xil_printf("No config found for %d\r\n", DMA_DEV_ID);
    		return XST_FAILURE;
    	}

    	Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
    	if (Status != XST_SUCCESS) {
    		xil_printf("Initialization failed %d\r\n", Status);
    		return XST_FAILURE;
    	}

    	if(XAxiDma_HasSg(&AxiDma)){
    		xil_printf("Device configured as SG mode \r\n");
    		return XST_FAILURE;
    	}

    	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

    	xil_printf("Start DMA transfer on  XAxiDma device \r\n");
    	Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr, MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
    	if (Status != XST_SUCCESS) {
    		return XST_FAILURE;
    	}

    	// configure test data generator
    	*((unsigned*)(DMA_DATA_GEN_ADDR + 4)) = (MAX_PKT_LEN/4) - 1;

    	xil_printf("Start test data generator \r\n");
    	*((unsigned*)(DMA_DATA_GEN_ADDR + 0)) = 1;

    	// Flush cache after transfer
		#ifdef __aarch64__
			Xil_DCacheFlushRange((UINTPTR)RxBufferPtr, MAX_PKT_LEN);
		#endif

    	// wait for transfer to finish
    	while ((XAxiDma_Busy(&AxiDma,XAXIDMA_DEVICE_TO_DMA)))
    	{
    		/* Wait */
    	}

    	xil_printf("Check received data: \r\n");
    	unsigned rxData = 0;
    	unsigned errCnt = 0;
    	for(unsigned i = 0; i < (MAX_PKT_LEN/4) - 1; i++)
    	{
    		rxData = Xil_In32(RxBufferPtr + i*4);
    		if(rxData != i)
    		{
    			errCnt++;
    		}
    	}
    	xil_printf(" %d bytes transfered \r\n", MAX_PKT_LEN - 1);
    	xil_printf(" %d errors found \r\n", errCnt);

    cleanup_platform();
    return 0;
}
