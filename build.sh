OUTPUT="ML-Scratch.playgroundbook"

cp "$SRCROOT/WWDC18/ViewController.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/WWDC18/BackgroundView.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/WWDC18/CanvasView.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/WWDC18/Helper.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/WWDC18/test1.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/WWDC18/Brain.swift" "$OUTPUT/Contents/Sources"
#cp "$SRCROOT/WWDC18/VisionViewController.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/WWDC18/ARViewController.swift" "$OUTPUT/Contents/Sources"

cp "$CODESIGNING_FOLDER_PATH/Assets.car" "$OUTPUT/Contents/PrivateResources"
cp -r "$CODESIGNING_FOLDER_PATH/Base.lproj/Main.storyboardc" "$OUTPUT/Contents/PrivateResources"
cp -r "$CODESIGNING_FOLDER_PATH/Vision.storyboardc" "$OUTPUT/Contents/PrivateResources"
cp -r "$CODESIGNING_FOLDER_PATH/AR.storyboardc" "$OUTPUT/Contents/PrivateResources"
#cp "$CODESIGNING_FOLDER_PATH/Assets.car" "$OUTPUT/Contents/Resources"
#cp -r "$CODESIGNING_FOLDER_PATH/Base.lproj/Main.storyboardc" "$OUTPUT/Contents/Resources"
##cp -r "$CODESIGNING_FOLDER_PATH/Vision.storyboardc" "$OUTPUT/Contents/Resources"
#cp -r "$CODESIGNING_FOLDER_PATH/AR.storyboardc" "$OUTPUT/Contents/Resources"
