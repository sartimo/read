# read

![image](https://github.com/sartimo/read/assets/71646577/6fa12d4d-f11f-4306-9868-cab878a04371)


a slightly lunatic implementation for a terminal reader using bash, html2text, pandoc, man and a custom book registry.

> note: don't kill me for the poor display and formatting within the generated man pages. I am still looking for a better formatting algo.


## usage 

simply configure the books you wanna read in the Readfile located at /home/$user/booktmp/Readfile.txt in the following format:

```txt
<shortcode>:<book URL>
```

then run the script and choose a book shortcode from the Readfile

```bash
chmod +x ./main.sh
./main.sh
```
