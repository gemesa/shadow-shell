#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// gets() was removed from the C11 standard
char* gets(char* str);

int authenticate(void)
{
    char buff[10];
    char cmd[10];
    int auth = 0;

    puts("enter the password:");
    gets(buff);
    
    if(strcmp(buff, "12345"))
    {
        puts("wrong password");
    }
    else
    {
        puts("correct password");
        auth = 1;

    }
    
    if(auth)
    {
        puts("authenticated");
        puts("your files:");
        strcpy(cmd, "ls");
        system(cmd);
    }

    return 0;
}

int main(void)
{
    authenticate();
    return 0;
}

void secret(void)
{
    puts("secret found!");
}
