*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    DateTime
Library    OperatingSystem
Library    RequestsLibrary

*** Variables ***
${NETFLIX_URL}       https://www.netflix.com/YourAccount
${EMAIL}             dimaanofamily000@gmail.com
${PASSWORD}          X103Justice*
${ALLOWED_DEVICES}   Google - Set Top Box    Xiaomi - Streaming Stick    Skyworth - Set Top Box    iPhone Chrome - Mobile Browser
${SLACK_WEBHOOK}    https://hooks.slack.com/services/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

*** Test Cases ***
Monitor Netflix Devices
    Open Netflix
    Login To Netflix
    Get Active Devices
    Validate Streaming Limits
    Logout Unwanted Devices
    Close Browser

*** Keywords ***
Open Netflix
    Open Browser    ${NETFLIX_URL}    browser=chrome
    Maximize Browser Window

Login To Netflix
    Input Text    name=email    ${EMAIL}
    Input Text    name=password    ${PASSWORD}
    Click Button    name=login
    Wait Until Page Contains    Your Account

Get Active Devices
    Click link    Manage Account
    Click Link    Devices
    Click link    Access and devices
    ${devices}=    Get WebElements    xpath=//div[@class='device-info']
    ${active_devices}=    Create List
    FOR    ${device}    IN    @{devices}
        ${device_name}=    Get Text    ${device}
        Append To List    ${active_devices}    ${device_name}
    END
    Set Global Variable    ${active_devices}

Validate Streaming Limits
    ${count}=    Get Length    ${active_devices}
    Run Keyword If    ${count} > 4    Send Slack Alert

Send Slack Alert
    ${message}=    Set Variable    "More than 4 devices are streaming on Netflix right now. System will now remove unknown devices"
    Create Session    slack    ${SLACK_WEBHOOK}
    ${payload}=    Create Dictionary    text=${message}
    POST On Session    slack    /    json=${payload}

Logout Unwanted Devices
    FOR    ${device}    IN    @{active_devices}
        ${is_allowed}=    Run Keyword If    '${device}' in @{ALLOWED_DEVICES}    Set Variable    True    False
        Run Keyword Unless    ${is_allowed}    Click Button    xpath=//button[contains(text(),'Sign out')]
    END
    Log    Logged out unwanted devices

Close Browser
    Close Browser