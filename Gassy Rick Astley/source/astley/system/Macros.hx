package astley.system;

class Macros {
    
    macro static public function generateHashes(password:String, salt:String = "") {
        
        password = password.toUpperCase();
        
        final exprs = [
            for (i in 0...password.length)
                macro $v{haxe.crypto.Md5.encode(password.substr(0, i + 1) + salt)}
        ];
        
        return macro $a{exprs};
    }
}