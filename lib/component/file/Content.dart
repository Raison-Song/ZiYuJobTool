import 'package:flutter/material.dart';
import 'package:zi_yu_job/component/file/FilesTree.dart';
import 'package:zi_yu_job/config/MyIcon.dart';

import '../../config/file/Style.dart';
import '../Content.dart';
import 'GetData.dart';

class FileContent{


  Widget getFileContent({String? groupName}){
    fileTree? tree=fileTree();
    if(groupName==null){
      //全部文件
      tree=GetData.filesTrees["root"];
    }else{
      tree=GetData.filesTrees[groupName];
    }

    print(tree);

    return ListView(
      children:
        getFileList(tree!,"",[])
      ,
    );
  }

  List<Widget> getFileList(fileTree files,String pre,List<Widget> filesWidget){
    if(files.isSpread||files.folderName=="root"){
      for(int i=0;i<files.folder.length;i++){
        filesWidget.add(getFileBtn(false, "  ${files.folder[i].folderName}", pre,
            isSpread: files.folder[i].isSpread,fileTree: files));
        getFileList(files.folder[i], "$pre      ",filesWidget);
      }

      for(int i=0;i<files.files.length;i++){
        filesWidget.add(getFileBtn(true, "  ${files.files[i]}", pre));
      }
    }

    return filesWidget;
  }

  Widget getFileBtn(bool isFile,String name,String pre,{bool? isSpread,fileTree? fileTree}){
    var icon=const Icon(Icons.folder,color: Color(0xffafafaf),);

    if(isFile){
      //默认格式
      icon=const Icon(Icons.text_snippet,color: Color(0xffafafaf));
      //判断文件格式
      String format=name.split(".")[name.split(".").length-1];
      if(["dox","docx","docm","dotx","dot"].contains(format)){
        icon=const Icon(MyIcons.word,color: Color(0xff185ABD));
      }
      if(["pptx","pptm","ppt","potx","potm","pot","ppsx","ppsm","pps","ppam","ppa"]
          .contains(format)) {
        icon=const Icon(MyIcons.ppt,color: Color(0xffc43e1c),);
      }
      if(["xlsx","xlsm","xlsb","xls","csv"].contains(format)){
        icon=const Icon(MyIcons.excel,color: Color(0xff107c41),);
      }
      if(["bmp","jpg","png","tif","gif","pcx","tga","exif","fpx","svg",
        "psd","cdr","pcd","dxf","ufo","eps","ai","raw","WMF","webp","avif","apng"]
          .contains(format)){
        icon=const Icon(MyIcons.photo);
      }
      if(["avi","wmv","mpg","mpeg","mov","rm","ram","swf","flv","mp4"].contains(format)){
        icon=const Icon(MyIcons.video);
      }
      if(["rar","zip","arj","z","7z"].contains(format)){
        icon=const Icon(MyIcons.zip,color: Color(0xff7e432d));
      }
      if("pdf"==format){
        icon=const Icon(MyIcons.pdf,color: Color(0xffafafaf),);
      }
      if("xml"==format){
        icon=const Icon(MyIcons.xml,color: Color(0xffafafaf));
      }
      if("java"==format){
        icon=const Icon(MyIcons.java,color: Color(0xff1c6578),);
      }
      if("html"==format){
        icon=const Icon(MyIcons.html,color: Color(0xffd84925),);
      }
      if(["sql","bak","mdb"].contains(format)){
        icon=const Icon(MyIcons.sql,color: Color(0xff8cd3ec),);
      }

      return TextButton(onPressed: (){}, child: Row(
        children: [
          Text(pre+"      "),
          icon,
          Text(name,style: FileStyle().getFileFont(),)
        ],
      ));
    }else{
      isSpread??=false;

      return TextButton(onPressed: (){
        //将文件夹设置为展开或关闭
        fileTree?.isSpread=!fileTree.isSpread;
        //重新渲染
        getContentWidget.updateFileContent();
      }, child: Row(
        children: [
          Text(pre),
          isSpread?const Icon(Icons.arrow_drop_down_rounded,color: Colors.grey,)
              :const Icon(Icons.arrow_right,color: Colors.grey),
          icon,
          Text(name,style: FileStyle().getFileFont(),)
        ],
      ));
    }
  }


}