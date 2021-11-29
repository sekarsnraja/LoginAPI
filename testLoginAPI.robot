*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections


*** Variables ***
${baseurl}=  http://localhost:8000


*** Test Cases ***
TC_001 Sign Up Post Request New Email
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com  name=Raja Sekar  password=raja@123
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   POST ON SESSION  APITesting  /signup  json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Successfully Created the User


TC_002 Sign Up Post Request Existing Mail
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com  name=Raja Sekar  password=raja@123
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   POST ON SESSION  APITesting  /signup  json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Email address already exists


TC_003 LogIn Post Request LogIn With Correct Email and Password
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com  password=raja@123
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   POST ON SESSION  APITesting  /login  json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  User logged in successfully


TC_004 LogIn Post Request LogIn with Email not Registered
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar456@gmail.com  password=raja@123
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   POST ON SESSION  APITesting  /login  json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Email not found, if new Please sign up before


TC_005 LogIn Post Request LogIn with wrong password
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com  password=raja@123wrong
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   POST ON SESSION  APITesting  /login  json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Wrong Password please try again


TC_006 LogIn GET Request on User Information with Registered EmailId
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com
    ${response}=   GET ON SESSION  APITesting  /login  params=${body}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Successfully fetched User detail


TC_007 LogIn GET Request on User Information with EmailId Not Registered
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123notregistered@gmail.com
    ${response}=   GET ON SESSION  APITesting  /login  params=${body}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Email not Found, if new user please signup


TC_008 allLoginUserDetails GET Request on Fetch all registered Users detail
    Create Session  APITesting  ${baseurl}
    ${response}=   GET ON SESSION  APITesting  /getLoginDetailsAll
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Successfully fetched all Users detail


TC_009 updateUser PATCH Request Update User Name or/and Password with Registered EmailId
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com  name=Sekar Raja  password=sekar@123
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   PATCH ON SESSION  APITesting  /updateUser   json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  User details updated Successfully


TC_010 updateUser PATCH Request Update User Name or/and Password with EmailId not Registered
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123wrong@gmail.com  name=Sekar Raja  password=sekar@123
    &{header}=  create dictionary  Content-Type=application/json
    ${response}=   PATCH ON SESSION  APITesting  /updateUser   json=${body}  headers=${header}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Email not Found, if new user please signup


TC_011 deleteUser DELETE Request to Delete Registered User
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123@gmail.com
    ${response}=   DELETE ON SESSION  APITesting  /deleteUser  params=${body}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  User deleted Successfully


TC_012 deleteUser DELETE Request to Delete Non Registered User
    Create Session  APITesting  ${baseurl}
    &{body}=  create dictionary  email=rajasekar123nonregistered@gmail.com
    ${response}=   DELETE ON SESSION  APITesting  /deleteUser  params=${body}
    Should Be Equal  ${response.status_code}  ${200}
    ${json_data}=  Set Variable  ${response.json()}
    ${message}=  Get From Dictionary  ${json_data}  message
    Should Be Equal  ${message}  Email not Found, if new user please signup
