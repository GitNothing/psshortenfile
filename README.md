<h2>About</h2>
A Powershell script use to shorten file length. Script will automatically consider uniqueness of each file name.

<h2>How to use</h2>
Put shortenFile.ps1 in the directory with the files that you want to shorten then right-click and run with Powershell.

<h2>Example output</h2>

```code
What is the minimum length?: 3

Rename      Original                               
------      --------                               
bea.txt     bear (2).txt                           
bear.txt    bear.txt                               
beare.txt   bearer123bearer123testtejfejsklfjfs.txt
bearer.txt  bearer123testefjs - Copy.txt           
bearer1.txt bearer123testeklsjf23123kljsklfjs.txt  
t.txt       t.txt                                  
tes.txt     testbear123eklsjfkljsklfjs.txt         


Confirm by typing y?: y
bear (2).txt => bea.txt
bear.txt => bear.txt
bearer123bearer123testtejfejsklfjfs.txt => beare.txt
bearer123testefjs - Copy.txt => bearer.txt
bearer123testeklsjf23123kljsklfjs.txt => bearer1.txt
t.txt => t.txt
testbear123eklsjfkljsklfjs.txt => tes.txt

-----Rename completed-----
```
