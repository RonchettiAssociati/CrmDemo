/*
 * Jakefile
 * RoACrm
 *
 * Created by Bruno Ronchetti on October 11, 2010.
 * Copyright 2010, Ronchetti & Associati All rights reserved.
 */

var ENV = require("system").env,
    FILE = require("file"),
    JAKE = require("jake"),
    task = JAKE.task,
    FileList = JAKE.FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug",
    OS = require("os");

app ("RoACrm", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "RoACrm.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("RoACrm");
    task.setIdentifier("com.yourcompany.RoACrm");
    task.setVersion("1.0");
    task.setAuthor("Ronchetti & Associati");
    task.setEmail("feedback @nospam@ yourcompany.com");
    task.setSummary("RoACrm");
    task.setSources((new FileList("**/*.j")).exclude(FILE.join("Build", "**")));
    task.setResources(new FileList("Resources/**"));
    task.setIndexFilePath("index.html");
    task.setInfoPlistPath("Info.plist");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

function printResults(configuration)
{
    print("----------------------------");
    print(configuration+" app built at path: "+FILE.join("Build", configuration, "RoACrm"));
    print("----------------------------");
}

task ("default", ["RoACrm"], function()
{
    printResults(configuration);
});

task ("build", ["default"]);

task ("debug", function()
{
    ENV["CONFIGURATION"] = "Debug";
    JAKE.subjake(["."], "build", ENV);
});

task ("release", function()
{
    ENV["CONFIGURATION"] = "Release";
    JAKE.subjake(["."], "build", ENV);
});

task ("run", ["debug"], function()
{
    OS.system(["open", FILE.join("Build", "Debug", "RoACrm", "index.html")]);
});

task ("run-release", ["release"], function()
{
    OS.system(["open", FILE.join("Build", "Release", "RoACrm", "index.html")]);
});

task ("deploy", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Deployment", "RoACrm"));
    OS.system(["press", "-f", FILE.join("Build", "Release", "RoACrm"), FILE.join("Build", "Deployment", "RoACrm")]);
    printResults("Deployment")
});
