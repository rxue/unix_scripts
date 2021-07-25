"""
int allowed - [1,3999]
reference: https://www.youtube.com/watch?v=yzB4M-UXqgI
"""
def intToRoman(integer:int) -> str:
    map = {1000:'M', 900:'CM', 500:'D', 400:'CD', 100:'C', 90:'XC',50:'L',40:'XL',10:'X',9:'IX',5:'V',4:'IV',1:'I'}
    if not 1 <= integer <= 3999:
        raise ValueError('Given integer has to be in range [1,3999]')
    result = None
    remainder = integer
    for key in map:
        singleResult = remainder // key
        if result is None:
            if singleResult > 0:
                result = map[key] * singleResult
        elif singleResult > 0:
            result = result + map[key] * singleResult  
        remainder %= key
    return result