import mmap

SMTP_PASSWORD="ssssss"
SMTP_PORT="wwwwww"


with open(r"./.env.test", "w") as file:
    file.write("SMTP_PASSWORD=" + repr(SMTP_PASSWORD) + '\n')
    file.write("SMTP_PORT=" + repr(SMTP_PORT) + '\n')

with open(r"./.env.test", "r") as file:
    for line in file:
        print(line)

with open(r"./.env.test") as file:
    s = mmap.mmap(file.fileno(), 0, access=mmap.ACCESS_READ)
    if s.find('SMTP_PORT') != -1:
        print('true')

# with open(r"./.env.test", "r") as file:
#     lines = file.readlines()
#     print(lines.index("SMTP_PORT\n"))