# Learning PowerShell DSC - Second Edition

This is the code repository for [Learning PowerShell DSC - Second Edition](https://www.packtpub.com/networking-and-servers/learning-powershell-dsc-second-edition?utm_source=github&utm_medium=repository&utm_campaign=9781787287242), published by [Packt](https://www.packtpub.com/?utm_source=github). It contains all the supporting project files necessary to work through the book from start to finish.

## About the Book
The main goal of this book is to teach you to configure, deploy, and manage your system using the new features of PowerShell v5/v6 DSC.

This book begins with the basics of PowerShell Desired State Configuration, covering its architecture and components. It familiarizes you with the set of Windows PowerShell language extensions and new Windows PowerShell commands that make up DSC. Then it helps you create DSC custom resources and work with DSC configurations with the help of practical examples. Finally, it describes how to deploy configuration data using PowerShell DSC. Throughout this book, we will be focusing on concepts such as building configurations with parameters, the local configuration manager, and testing and restoring configurations using PowerShell DSC.

By the end of the book, you will be able to deploy a real-world application end-to-end and will be familiar enough with the powerful Desired State Configuration platform to achieve continuous delivery and efficiently and easily manage and deploy data for systems.

## Instructions and Navigation
All of the code is organized into folders. Each folder starts with a number followed by the application name. For example, Chapter02.



The code will look like the following:
```
# data file
@{
  AllNodes = @(
    @{
      NodeName = "server1"
    },
    @{
      NodeName = "server2"
    }
  );
  NonNodeData = @{
    ConfigFileContents = (Get-Content "Config.xml")
  }
}
```
###Using the Code

To build and run the code provided you must have the following Operating Systems and software

Operating Systems

- Windows 2012 or Windows 2012 R2
- Windows 8.1 or Windows 10

Software

- Windows Management Framework v4
- Windows Management Framework v5


## Related Products
* [PowerShell: Automating Administrative Tasks](https://www.packtpub.com/networking-and-servers/powershell-automating-administrative-tasks?utm_source=github&utm_medium=repository&utm_campaign=9781787123755)

* [PowerShell 5 Recipes [Video]](https://www.packtpub.com/networking-and-servers/powershell-5-recipes-video?utm_source=github&utm_medium=repository&utm_campaign=9781787124820)

* [Mastering Windows PowerShell 5 Administration [Video]](https://www.packtpub.com/networking-and-servers/mastering-windows-powershell-5-administration-video?utm_source=github&utm_medium=repository&utm_campaign=9781786467980)

### Suggestions and Feedback
[Click here](https://docs.google.com/forms/d/e/1FAIpQLSe5qwunkGf6PUvzPirPDtuy1Du5Rlzew23UBp2S-P3wB-GcwQ/viewform) if you have any feedback or suggestions.
