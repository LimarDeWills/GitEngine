workspace "Engine"
   architecture "x64"
   startproject "Sandbox"

   configurations
   {
      "Debug",
      "Release",
      "Dist"
   }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

--Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Engine/vendor/GLFW/include"
IncludeDir["Glad"] = "Engine/vendor/Glad/include"
IncludeDir["ImGui"] = "Engine/vendor/ImGui"

group "Dependencies"
	include "Engine/vendor/GLFW"
	include "Engine/vendor/Glad"
	include "Engine/vendor/ImGui"
group ""

project "Engine"
   location "Engine"
   kind "SharedLib"
   language "C++"
   staticruntime "off"

   targetdir ("bin/" .. outputdir .."/%{prj.name}")
   objdir ("bin-int/" .. outputdir .."/%{prj.name}")

   pchheader "egpch.h"
   pchsource "Engine/src/egpch.cpp"
   files
   {
      "%{prj.name}/src/**.h",
      "%{prj.name}/src/**.cpp"
   }
   includedirs
   {
      "%{prj.name}/src",
      "%{prj.name}/vendor/spdlog/include",
      "%{IncludeDir.GLFW}",
	  "%{IncludeDir.Glad}",
	  "%{IncludeDir.ImGui}",
   }
   links
   {
      "GLFW",
	  "Glad",
	  "ImGui",
      "opengl32.lib"
   }
   filter "system:windows"
   
      cppdialect "C++17"
      systemversion "latest"
      defines
      {
         "EG_PLATFORM_WINDOWS",
         "EG_BUILD_DLL",
		 "GLFW_INCLUDE_NONE"
      }
   postbuildcommands 
   {
      --("IF NOT EXISTS ../bin/" .. outputdir .. "/Sandbox mkdir ../bin/" .. outputdir .. "/Sandbox")
      ("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
   }

   filter "configurations:Debug"
      defines "EG_DEBUG"
      runtime "Debug"
	   symbols "On"
	   
      filter "configurations:Release"
      defines "EG_RELEASE"
      runtime "Release"
	   optimize "On"

      filter "configurations:Dist"
      defines "EG_DIST"
	  runtime "Release"
      optimize "On"
       
project "Sandbox"
   location "Sandbox"
   kind "ConsoleApp"
   language "C++"
   staticruntime "off"
   
   targetdir ("bin/" .. outputdir .."/%{prj.name}")
   objdir ("bin-int/" .. outputdir .."/%{prj.name}")
   
   files
   {
      "%{prj.name}/src/**.h",
      "%{prj.name}/src/**.cpp"
   }
   
   includedirs
   {
      "Engine/vendor/spdlog/include",
      "Engine/src"
   }
   
   links
   {
      "Engine"
   }
   
   filter "system:windows"
   
      cppdialect "C++17"
      systemversion "latest"
      
      defines
      {
         "EG_PLATFORM_WINDOWS"
      }
   
   filter "configurations:Debug"
      defines "EG_DEBUG"
      runtime "Debug"
	   symbols "On"
	        
      filter "configurations:Release"
      defines "EG_RELEASE"
	  runtime "Release"
      optimize "On"
      
      filter "configurations:Dist"
      defines "EG_DIST"
	  runtime "Release"
      optimize "On"