NAME=myservice

@"
{
    "service": "$name",
    "environment": "$env:ENVIRONMENT",
    "any_env_special_info": "$env:MYSERVICE_SPECIAL_INFO"
}
"@ | Out-File -Encoding ascii -FilePath "C:\$name\health"


Restart-Service $name