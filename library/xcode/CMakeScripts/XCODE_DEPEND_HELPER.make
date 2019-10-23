# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.igl.Debug:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Debug/libigl.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Debug/libigl.a


PostBuild.library.Debug:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Debug/liblibrary.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Debug/liblibrary.a


PostBuild.igl.Release:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Release/libigl.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Release/libigl.a


PostBuild.library.Release:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Release/liblibrary.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/Release/liblibrary.a


PostBuild.igl.MinSizeRel:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/MinSizeRel/libigl.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/MinSizeRel/libigl.a


PostBuild.library.MinSizeRel:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/MinSizeRel/liblibrary.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/MinSizeRel/liblibrary.a


PostBuild.igl.RelWithDebInfo:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/RelWithDebInfo/libigl.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/RelWithDebInfo/libigl.a


PostBuild.library.RelWithDebInfo:
/Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/RelWithDebInfo/liblibrary.a:
	/bin/rm -f /Users/ziqwang/Documents/GitHub/LearnRender/library/xcode/RelWithDebInfo/liblibrary.a




# For each target create a dummy ruleso the target does not have to exist
