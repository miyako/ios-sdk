

frameworks_folder=Carthage/Build/iOS
archs="i386 armv7"

for arch in $archs
do
  # echo "strip arch "$arch
  for framework in $frameworks_folder/*
  do
      if [[ -d $framework ]]; then
        filename=$(basename "$framework")
        name="${filename%.*}"
        extension="${framework##*.}"

        if [[ $extension = "framework" ]]; then

          file_path="$framework/$name"
          # echo " - strip framework "$name
          c=`lipo -info "$file_path" | grep $arch | wc -l`
          if [ $c = 1 ]; then
            lipo -remove $arch  "$file_path" -output "$file_path"
            echo "$arch stripped from $name"

            if test -f "$framework/Modules/$name.swiftmodule/$arch.swiftdoc"; then
              echo "$framework/Modules/$name.swiftmodule/$arch.swiftdoc exist"
            else
              echo "$framework/Modules/$name.swiftmodule/$arch.swiftdoc not exist"
            fi
            rm -f $framework/Modules/$name.swiftmodule/$arch.swiftdoc
            rm -f $framework/Modules/$name.swiftmodule/$arch.swiftmodule
          fi

          # symbols
          file_path=$framework".dSYM/Contents/Resources/DWARF/$name"
          if [ -f "$file_path" ]; then
            # echo " - strip symbols "$name
            c=`lipo -info "$file_path" | grep $arch | wc -l`
            if [ $c = 1 ]; then
              lipo -remove $arch  "$file_path" -output "$file_path"
              echo "$arch stripped from symbols $name"
            fi
          fi
      fi
    fi
  done
done
