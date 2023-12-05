f = open("./day3.txt", "r")
input = f.read()
facts = []

lines = input.splitlines()

for i in range(len(lines)):
    for j in range(len(lines[i])):
        if lines[i][j] != ".":
            facts.append([j, i, lines[i][j]])

for fact in facts:
    f = open("facts.txt", "a")
    if fact[2].isnumeric():
        f.write(f"cell({fact[0]}, {fact[1]}, {fact[2]}).\n")
    else:
        f.write(f"cell({fact[0]}, {fact[1]}, '{fact[2]}').\n")
    f.close()
