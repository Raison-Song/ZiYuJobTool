//文件结构树
class fileTree {
  fileTree({String? folder}) {
    //如无目录名，则为根目录
    folder ??= "root";
    //todo 对root进行转义
    folderName = folder;
  }

  //当前目录名
  String folderName = "";

  //是否展开
  bool isSpread = false;

  //子目录
  List<fileTree> folder = <fileTree>[];

  //当前目录下文件
  List<String> files = <String>[];

  void setFile(String fileName, {String? preFolder}) {
    //todo 查询是否存在重复的文件名
    preFolder ??= "root";
    //遍历目录
    var prefolderNode = getFolder(preFolder);
    if (prefolderNode != null) {
      prefolderNode.files.add(fileName);
    } else {
      print("目录名不存在");
    }
  }

  fileTree getFolder(String folderName) {
    if (this.folderName == folderName) {
      return this;
    }
    for (int i = 0; i < folder.length; i++) {
      if (folder[i].getFolder(folderName).folderName != "null") {
        return folder[i].getFolder(folderName);
      }
    }
    return fileTree(folder: "null");
  }

  void setFolder(String folderName,{String? preFolder}) {//todo 查询是否存在重复的文件名
    preFolder ??= "root";
    //遍历目录
    var prefolderNode = getFolder(preFolder);
    if (prefolderNode != null) {
      prefolderNode.folder.add(fileTree(folder: folderName));
    } else {
      print("目录名不存在");
    }
    // folder.add(fileTree(folder: folderName));
  }

  String toStrings({String? pre}) {
    pre ??= "";
    String print = "$folderName\n";
    for (int i = 0; i < folder.length; i++) {
      if(i==folder.length-1&&files.isEmpty){
        print += pre + "└——" + folder[i].toStrings(pre: pre + "    ");
      }else{
        print += pre + "├——" + folder[i].toStrings(pre: pre + "│   ");
      }
    }
    for (int i = 0; i < files.length; i++) {
      if(i==files.length-1){
        print += pre + "└——" + files[i] + "\n";
      }else{
        print += pre + "├——" + files[i] + "\n";
      }
    }
    return print;
  }
}


