
# Character Classes and Wildcards
| Regex  | Means                                                   |
|:----   |:----                                                    |
| .      | Any character except a newline                          |
| \d     | Any digit [0-9]                                         |
| \D     | Any non-digit [^0-9]                                    |
| \w     | Any word character (letters, numbers, underscore)       |
| \W     | Any non-word character                                  |
| \s     | Any whitespace character (space, tab, newline)          |
| \S     | Any non-whitespace character                            |
| [abc]  | Match any character inside the brackets                 |
| [^abc] | Match any character not inside the brackets (negation)  |
| [a-z]  | Match any character in the range a through z            |

# Quantifiers
| Regex | Means                                                   |
|:----  |:----                                                    |
| *     | Match 0 or more times (greedy)                          |
| *?    | Match 0 or more times (lazy/non-greedy)                 |
| +     | Match 1 or more times (greedy)                          |
| +?    | Match 1 or more times (lazy/non-greedy)                 |
| ?     | Match 0 or 1 time (optional)                            |
| {n}   | Match exactly n times                                   |
| {n,}  | Match at least n times                                  |
| {n,m} | Match between n and m times                             |

# Anchors and Boundaries
| Regex | Means                                                   |
|:----  |:----                                                    |
| ^     | Start of the string or line                             |
| $     | End of the string or line                               |
| \b    | Word boundary                                           |
| \B    | Non-word boundary                                       |

# Groups and Logic
| Regex   | Means                                                   |
|:----    |:----                                                    |
| (...)   | Capturing group                                         |
| (?:...) | Non-capturing group                                     |
| \1      | Backreference to group 1                                |
| a|b     | Alternation (match a or b)                              |
