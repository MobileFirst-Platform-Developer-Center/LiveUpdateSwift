/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package com.github.mfpdev;

import com.ibm.mfp.adapter.api.ConfigurationAPI;
import com.ibm.mfp.adapter.api.OAuthSecurity;
import com.ibm.watson.developer_cloud.text_to_speech.v1.TextToSpeech;
import com.ibm.watson.developer_cloud.text_to_speech.v1.model.Voice;
import io.swagger.annotations.*;
import org.apache.commons.io.IOUtils;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

@Api(value = "Text To Speech Adapter")
@Path("/")
public class TextToSpeechAdapterResource {

	static Logger logger = Logger.getLogger(TextToSpeechAdapterResource.class.getName());

	@Context
	ConfigurationAPI configApi;

	private static final Map<String, Voice> VOICE_MAP;

	static {
		VOICE_MAP = new HashMap<String, Voice>();

		//ES
		VOICE_MAP.put("ES_ENRIQUE", Voice.ES_ENRIQUE);
		VOICE_MAP.put("ES_LAURA", Voice.ES_LAURA);
		VOICE_MAP.put("ES_SOFIA", Voice.ES_SOFIA);

		//EN
		VOICE_MAP.put("EN_LISA", Voice.EN_LISA);
		VOICE_MAP.put("EN_ALLISON", Voice.EN_ALLISON);

		//IT
		VOICE_MAP.put("IT_FRANCESCA", Voice.IT_FRANCESCA);

		//FR
		VOICE_MAP.put("FR_RENEE", Voice.FR_RENEE);

		//DE
		VOICE_MAP.put("DE_DIETER", Voice.DE_DIETER);
		VOICE_MAP.put("DE_GIRGIT", Voice.DE_GIRGIT);

		//GB
		VOICE_MAP.put("GB_KATE", Voice.GB_KATE);
	}

	@ApiOperation(value = "Text to speech", notes = "Return audio file based on the voice type and text")
	@ApiResponses(value = { @ApiResponse(code = 200, message = "audio/wav is returned") })
	@GET
	@Produces("audio/wav")
	@OAuthSecurity(scope = "configuration-user-login")
	@Path("/textToSpeech")
	public Response speechToText(@ApiParam (defaultValue = "Hello Live Update", required = true) @QueryParam("text") String text, @ApiParam (defaultValue = "EN_LISA", required = true)
			@QueryParam("voice") String voice) {
		TextToSpeech service = new TextToSpeech();
		service.setUsernameAndPassword(configApi.getPropertyValue("textToSpeechUser"), configApi.getPropertyValue("textToSpeechPassword"));

		InputStream voiceInputStream = service.synthesize(text, VOICE_MAP.get(voice), "audio/wav");

		byte[] bytes = new byte[0];
		try {
			bytes = IOUtils.toByteArray(voiceInputStream);
		} catch (IOException e) {
			return Response.serverError().build();
		}
		return Response.ok(bytes, "audio/wav").build();
	}



}
