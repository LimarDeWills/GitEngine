project "Glad"
    kind "StaticLib"
    language "C"
  
    targetdir ("bin/" .. outputdir .. "/%(name)")
    objdir ("bin-int/" .. outputdir .. "/%(name)")
    
    files
    {
	   "include/glad/glad.h",
	   "include/KHR/khrplatform.h",
	   "src//glad.c"
	
    }
    
    includedirs
    {
		"include"
	}

   filter "system:windows"
     systemversion "latest"
     staticruntime "On"
    
     
   filter {"system:windows", "configurations:Release"}
      buildoptions "/MT"