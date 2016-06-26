/*
 *    Licensed Materials - Property of IBM
 *    5725-I43 (C) Copyright IBM Corp. 2015. All Rights Reserved.
 *    US Government Users Restricted Rights - Use, duplication or
 *    disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

package com.github.mfpdev;

import java.util.logging.Logger;
import java.util.*;

import com.ibm.mfp.adapter.api.MFPJAXRSApplication;

public class TextToSpeechAdapterApplication extends MFPJAXRSApplication{

	static Logger logger = Logger.getLogger(TextToSpeechAdapterApplication.class.getName());
	

	protected void init() throws Exception {
		logger.info("Adapter initialized!");
	}
	

	protected void destroy() throws Exception {
		logger.info("Adapter destroyed!");
	}
	

	protected String getPackageToScan() {
		return getClass().getPackage().getName();
	}
}
