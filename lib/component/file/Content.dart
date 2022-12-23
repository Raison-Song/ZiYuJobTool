import 'package:flutter/material.dart';
import 'package:zi_yu_job/component/file/FilesTree.dart';
import 'package:zi_yu_job/config/MyIcon.dart';

import '../../config/file/Style.dart';
import '../Content.dart';
import 'GetData.dart';

class FileContent{
  //通过组名获取文件树按钮
  //此时文件树数据已经从数据库取出
  Widget getFileContent({String? groupName}){

    groupName??="main";

    fileTree? tree=GetData.filesTrees[groupName];

    //如果tree为null，则显示没有文件
    if(tree==null||
        (tree.files.isEmpty&&tree.folder.isEmpty)
    ){
      return const  Text("目录下为空");
    }

    print(tree.toStrings());
    return ListView(
      children:
        getFileList(tree,"",[],groupName)
      ,
    );
  }

  List<Widget> getFileList(fileTree files,String pre,List<Widget> filesWidget,String groupName){
    var spreadList=GetData.filesTreesIsSpread[groupName];
    spreadList??=[];

    print("读取时：");
    print(spreadList);

    if(spreadList.contains(files.folderName)||files.folderName=="root"){
      for(int i=0;i<files.folder.length;i++){
        filesWidget.add(getFileBtn(false, files.folder[i].folderName, pre,groupName,
            fileTree: files));
        getFileList(files.folder[i], "$pre      ",filesWidget,groupName);
      }

      for(int i=0;i<files.files.length;i++){
        filesWidget.add(getFileBtn(true, files.files[i], pre,groupName));
      }
    }

    return filesWidget;
  }

  Widget getFileBtn(bool isFile,String name,String pre,String groupName,{fileTree? fileTree}){
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
          Text(" "+name,style: FileStyle().getFileFont(),)
        ],
      ));
    }else{
      bool isSpread;

      List<String>? isSpreadList=GetData.filesTreesIsSpread[groupName];
      if(isSpreadList==null){
        GetData.filesTreesIsSpread.addAll({groupName:[]});
      }
      isSpreadList??=[];

      isSpread=isSpreadList.contains(name);

      return TextButton(onPressed: (){
        //将文件夹设置为展开或关闭
        fileTree?.isSpread=!fileTree.isSpread;
        //更改文件夹展开情况
        isSpread?GetData.filesTreesIsSpread[groupName]?.remove(name)
            :GetData.filesTreesIsSpread[groupName]?.add(name);

        //重新渲染
        getContentWidget.updateFileContent();
        }, child: Row(
          children: [
            Text(pre),
            isSpread?const Icon(Icons.arrow_drop_down_rounded,color: Colors.grey,)
              :const Icon(Icons.arrow_right,color: Colors.grey),
            icon,
            Text(" "+name,style: FileStyle().getFileFont(),)
          ],
        )
      );
    }
  }


}

