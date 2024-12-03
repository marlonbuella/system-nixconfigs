{ pkgs, ... }:

{
    programs.git = {
        enable = true;
        
        config = {
            user = {
                name = "Alon Buella";
                email = "marlon.b.buella@gmail.com";
            };
        };
    };
}