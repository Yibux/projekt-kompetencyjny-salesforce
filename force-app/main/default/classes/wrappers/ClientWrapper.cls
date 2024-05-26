public with sharing class ClientWrapper {
    public String mail;
    public String hash;
    public String firstName;
    public String lastName;
    public String oldHash;

    public ClientWrapper() {
        this.mail = mail;
        this.hash = hash;
        this.firstName = firstName;
        this.lastName = lastName;
        this.oldHash = oldHash;
    }
}

//dodać metodę deszyfrującą wiadomość wywoływaną w konstruktorze