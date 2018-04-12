# LunaAPI2Swagger

This program generates the Swagger (OpenAPI 2.0) documentation for your API.  

This program works together with LunaAPIDocGen (https://github.com/eurog33k/LunaAPIDocGen) which generates the call definitions for this program.  

Since the results of the run that generates the swagger file are stored in a local SQLite database, you can use this program to Unit Test your API.  

## How to generate the swagger.json file
**Important note: Before starting LunaAPIDocGen, place the apidocsluna.db sqlite database from the externals folder under SpecialFolder.ApplicationData. If you are using LunaAPIDocGen to generate the call definitions, you can skip this step, since LunaAPIDocGen already required this step, so the file is already in place**  

### Open LunaAPI2Swagger:

If this is the first time you run the project, you need to first set certain settings and the parameter values for the tests.  

In module modquestions (api2swagger/lib folder) adjust the following properties:  
• aboutq_basepath  
• aboutq_httpq  
• aboutq_httpsq  
• aboutq_infoq  

In the module execute (api2swagger/lib folder) adjust the value of the following constants  
• APIHost  
• AuthorizationKey  
• strAPIBasePath  

You also need to personalize the tests:  
Enter the parameters in the properties of the APICalls class (use the same parameternames as under APICallDocs). Make sure you enter values for the required parameters  

For more information see the step by step guide at https://lunaapi.ga/publish-swagger/publish-swagger-1.html  

**NOTE: This needs to be in binary format. Don't use Xojo text format or the documentation for xjDocs will be corrupt and you won't be able to open your project any more.**

### Run the LunaAPI2Swagger project 

### Click the "execute tests" button 
The run will generate the required swagger.json file under SpecialFolder.ApplicationData  

### Upload the swagger documentation
Upload the generated swagger File to the db folder next to the Luna app on the server.  
You can change the location for this file in the source code of the Luna project at https://github.com/eurog33k/luna if you want.  

## Special Thanks
Based on or uses code from the following projects:  

|  Project Name           | GitHub URL                                          |
| ----------------------- | ----------------------------------------------------|
|  api2swagger            | https://github.com/anil614sagar/api2swagger         | 
|  JSONItem_MTC           | https://github.com/ktekinay/JSONItem_MTC            |
|  RB-URI                 | https://github.com/charonn0/RB-URI                  | 
|  node-http-status       | https://github.com/adaltas/node-http-status         |
|  json-schema-generator  | https://github.com/krg7880/json-schema-generator    |

For the respective licenses of these projects, see the LunaAPI2Swagger Xojo Project source code  
