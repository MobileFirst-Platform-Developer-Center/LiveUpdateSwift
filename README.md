### Hello Live Update

Simple hello world demo which show the Live Update feature.  The demo let you choose your prefered langauge and then say "Hello World" in the selected langauge or display dialog instead. The sample usign the ["Text to Speech" service in Watson](http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/text-to-speech.html). For each segment (country / lagauge) you can then change the "hello text" or the prefered voice and accent.

##See it in action
[![Live Update Demo](https://img.youtube.com/vi/lWYdeogj0X0/0.jpg)](https://www.youtube.com/watch?v=lWYdeogj0X0)

## Run the sample

1. Deploy the LiveUpdate Adapter
  * Follow the [Adding Live Update to MobileFirst Server section](https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/using-the-mfpf-sdk/live-update/#adding-live-update-to-mobilefirst-server)
2. Import the Live Update scheme
  * [Click to download]() the scheme for the sample
3. Add segments under the `Live Update Settings` Segments tab. Add the following segments IDs:
  1. DE
  2. FR
  3. ES
  4. UK
  5. IT
  6. US

  Each segment gets the default value from the scheme, so change each one according to the spoken language.  For an example:
  For France add the following:
  1. isVoiceEnabled - change to true
  2. voice - FR_RENEE
  3. helloText - Bonjour le monde

3. Deploy the Text to Speech Adapter
4. Live Update adapter configuration
5. Text to Speech Adapter configuration
6. Register the App
7. Run the App

#### Note:
To be able to see immediate changes go to Live `Update Adapter` configuration tab  and set the `expirationPeriod` to be short value (e.g: 5 seconds)

## Supported Versions
IBM MobileFirst Platform Foundation 8.0

##Licence
Copyright 2016 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
