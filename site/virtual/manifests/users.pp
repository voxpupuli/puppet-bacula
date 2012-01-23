class virtual::users {
  include virtual::groups
  include virtual::ssh_authorized_keys
  include virtual::users::service
  include virtual::users::customers
  include virtual::users::external

 # use 1100+ for accounts

 @account::user {'luke':
    comment => 'Luke Kanies',
    uid     => '1101',
    group   => allstaff,
    tag     => allstaff,
 }

 @account::user {'teyo':
    comment => 'Teyo, Tyree',
    uid     => '1102',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'markus':
    comment => 'Markus Roberts',
    ensure  => absent,
    uid     => '1106',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'dan':
    comment => 'Dan Bode',
    uid     => '1109',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
 }

 @account::user {'jeff':
    comment => 'Jeff McCune',
    uid     => '1112',
    shell   => '/bin/zsh',
    group   => allstaff,
    groups  => ["prosvc","release","infra"],
    tag     => allstaff,
 }

 @account::user {'matt':
    comment => 'Matt Robinson',
    uid     => '1114',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'nick':
    comment => 'Nick Lewis',
    uid     => '1115',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'nan':
    comment => 'Nan Liu',
    uid     => '1117',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
 }

 @account::user {'james':
    comment => 'James Turnbull',
    uid     => '1118',
    group   => allstaff,
    groups  => ["sysadmin","operations","techops"],
    tag     => allstaff,
 }

 @account::user {'cody':
    comment => 'Cody Herriges',
    uid     => '1119',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
 }

 @account::user {'jose':
    comment => 'Jose Palafox',
    uid     => '1120',
    group   => allstaff,
    groups  => ["prosvc","operations"],
    tag     => allstaff,
 }

 @account::user {'jhelwig':
    comment => 'Jacob Helwig',
    uid     => '1121',
    group   => allstaff,
    groups  => ["developers","enterprise","release"],
    tag     => allstaff,
 }

 @account::user {'zach':
    comment => 'Zach Leslie',
    uid     => '1123',
    shell   => '/bin/zsh',
    group   => allstaff,
    groups  => ["sysadmin","operations","techops","infra"],
    tag     => allstaff,
 }

 @account::user {'djm':
    comment => 'Dominic Maraglia',
    uid     => '1124',
    group   => allstaff,
    groups  => ["developers","qa"],
    tag     => allstaff,
 }

 @account::user {'nigel':
    comment => 'Nigel Kersten',
    group   => allstaff,
    uid     => '1127',
    groups  => ["prosvc","enterprise"],
    tag     => allstaff,
 }

 @account::user {'pberry':
    comment => 'Paul Berry',
    ensure  => absent,
    uid     => '1128',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'gh':
    comment => 'Garrett Honeycutt',
    uid     => '1129',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
 }

 @account::user {'nfagerlund':
    comment => 'Nick Fagerlund',
    uid     => '1130',
    group   => allstaff,
    groups  => ["developers","operations","release"],
    tag     => allstaff,
 }

 @account::user {'hunter':
    comment => 'Hunter Haugen',
    uid     => '1131',
    shell   => "/bin/zsh",
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
 }

 @account::user {'daniel':
    comment => 'Daniel Pittman',
    uid     => '1134',
    group   => allstaff,
    groups  => ["developers","enterprise"],
    tag     => allstaff,
 }
 
 @account::user {'max':
    comment => 'Max Martin',
    uid     => '1136',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'pvande':
    comment => 'Pieter van de Bruggen',
    uid     => '1143',
    group   => allstaff,
    shell   => '/bin/bash',
    groups  => ["developers"],
    tag     => allstaff,
 }

 @account::user {'josh':
    comment => 'Josh Cooper',
    uid     => '1146',
    group   => allstaff,
    groups  => ["developers"],
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAvzpmN2hQEscKJZjef6fDpuYpDGJLVY9UX9yNDpvBEJNVK2kfocnxCfsA7dIqkNTW6ly7VQwKpZR0tjt62sBPaYSXdrd5du0CV9EqBab+AMQ3khxbq5XdID3BlQySzkGjnjISGicEqfL9KbQSSc1DAduWahXt2isRqpCpID1NzE1H0c6HLstWuSQv+iPFkwi4PUpzyuOieJHK3UVA7/6iZrbMavol+xjVimtQLTy8vlfS3zY+gFNf6olNZ4UgQXtNFUhCpc7XugiqvLG8k+5CdF02E1kH3Pc4GdNm1QsrgxAtK9WUOfZsyhmSk5dnDubJJW+Dbv74mLe4bcFBAUH2Dw==',
    tag     => allstaff,
 }

 @account::user {'stahnma':
    comment => 'Michael Stahnke',
    uid     => '1147',
    group   => allstaff,
    groups  => ["developers","release","enterprise","builder","infra"],
    tag     => allstaff,
 }

  @account::user {'ben':
    comment => 'Ben Hughes',
    uid     => '1025',
    group   => allstaff,
    shell   => '/bin/zsh',
    groups  => ["sysadmin","operations","techops","infra"],
    tag     => allstaff,
  }

 @account::user {'ken':
    comment => 'Ken Barber',
    uid     => '1142',
    group   => allstaff,
    groups  => ["prosvc"],
    shell   => '/bin/bash',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA04dOEngfuA7phW/0yWH/gBV11udAGvuUhClyuuA3n6MRxYnSei8JBtTFeGNjgKRsxSqv5rTf9HnIHTC5ECMhnjV3bUYdRxs76RlFghYpldBgDEDurgZZgzZWsUALkLwMXH+CzQ7bY/UeYa8gOt/XfjewhL/BStmlJ2/DiFychKP+BoxrIxv3p7tdM9yvaUviLoomD9rEZzT+3bvSloVWo2lh9Q8LcexuZUnLTKA5C4gCk6mq8PutU/Non3NCZaOUntTN7qvk+NIMGxxXFzYIDDP3c61Cwq/z0PshHAcWVHganNxEdNFhfPt+E7SGVeGHAoHgXnTsX4bYKeClMnz8nQ==',
    keytype => "ssh-rsa",
    tag     => allstaff,
 }

  @account::user {'adrien':
    comment => 'Adrien Thebo',
    uid     => '1026',
    group   => allstaff,
    groups  => ["sysadmin","operations","techops","infra"],
    shell   => '/bin/bash',
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAr/PYSBs0degY8/NxTZAsidGG+9Wnqb6RQxqm+HRK+Jc4toetKOvXVfwCKQczTwpuKlS3bT0MREv2Ur4boFm7jWGy01y0cJBLjBQEsefWjb3jlQIuYZcaYBlzSq1PlzeuTHcc86k34gvL0uKojYmc43kX/ao3o3yIp4/7SlKJVpYikWNB0NDOokeGEr440GwAGUzybgur/Vfm+aYa9k0wigCC386S1/l4MQ3dDI8D83fOZnyHVOmyjBFL/Nz2Q3Xy4P/Sey8g40SoO4UjNtGmZRmwmdUaF1p1i1BDW7wqsFBYwKeLKv8ZjNo+zy0Mflm2KFnrHBd1FOzymYV3g1biyw==",
    keytype => "ssh-rsa",
    tag     => allstaff,
  }
  @account::user {'spencer':
    comment => 'Spencer Krum',
    uid     => '1027',
    group   => allstaff,
    groups  => ["interns","builder"],
    tag     => allstaff,
    ensure  => absent,
  }
  @account::user {'matthaus':
    comment => 'Matthaus Litteken',
    uid     => '1028',
    group   => allstaff,
    groups  => ["developers","builder","release","enterprise","infra"],
    tag     => allstaff,
  }

  @account::user {'gary':
    comment => 'Garry Larizza',
    uid     => '1148',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
  }

  @account::user {'ccaum':
    comment => 'Carl Caum',
    uid     => '1149',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
  }

  @account::user {'cameron':
    ensure  => absent,
    comment => 'Cameron Thomas',
    uid     => '1150',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
  }

  @account::user {'deepak':
    comment => 'Deepak Giridharagopal',
    uid     => '1151',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
  }

  @account::user {'eric':
    comment => 'Eric Shamow',
    uid     => '1152',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
  }

  @account::user {'lifton':
    comment => 'Josh Lifton',
    uid     => '1153',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
  }

  @account::user {'dhogland':
    comment => 'Dan Hogland',
    uid     => '1154',
    group   => allstaff,
    groups  => ["prosvc"],
    tag     => allstaff,
  }

  @account::user {'mhiggins':
    comment => 'Michael Higgins',
    uid     => '1155',
    group   => allstaff,
    groups  => ["qa"],
    tag     => allstaff,
  }

  @account::user {'randall':
    comment => 'Randall Hansen',
    uid     => '1156',
    group   => allstaff,
    groups  => ["developers"],
    tag     => allstaff,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAgEAqrj3WxcYmIU4IJVRjXNB9Ea97Fm76Y8KXl8T93Lm5VTS8WsWtz0vaZpqz8TsXoMFes595KgcNWIg+GPSAwT5gqZEKDmSS19rxy9S60TV6C6pe9BYiDsRVYPPlzSklFkzyPPVl1TUlIJhLsWRCLFY3b0kEulpwwDHS/pu0yRnP7Ht0r28KTCu88KKz1GN9HlcarjLPXQK2yo1GHFTNs6/1s/NAZadP1PkquhR8aOHvz4k4dmaRPt7eJK6aKiKaPQKt/CEPoG9bxPhEczweKNO4UZUKr7mhARiMtnhYcEoc59Q7wh6DgqYBUFr241H3m+CBo8Ft4hSxJuGv+vkyKftOM3g4ESqxSHEWZ7t8QsdFPsdb7PWuGsob5f4S4Pamgfw85exljN1sRcFT3kE7IsZpQaq8ikIoP+oMc+RrgVTDqhxMao9lSEomq6Qcq5RbrwhCjklzsA2uyvygHqwd7T57MMarQlxdMtI0vQPoGXvW6Xmuxq2tRd8pcAR7g9Ucy7q1R732kbCakwyR4HJvCNQL4smZ/dcRedPMg9/JFaUEu8om/dCvoUtVvITBRfqcoTvs/k/eqlgsnxN/DQ4OXhaOjDIic9Xn3NYJvxldhWYLQj75qx9H6qbhrEKZuJOGQm3ukaZZb+Hf0JjKuUukxi3DqzKsJwUUA+9/oGDcnNwoRE=",
    keytype => "ssh-rsa",
  }

  @account::user {'justin':
    comment => 'Justin Stoller',
    uid     => '1157',
    group   => allstaff,
    groups  => ["qa"],
    tag     => allstaff,
  }

  @account::user {'jonathan':
    ensure  => absent,
    comment => 'Jonathan Grochowski',
    uid     => '1158',
    group   => allstaff,
    groups  => ["developers","release","builder"],
    tag     => allstaff,
  }

  @account::user {'ssvarma':
    comment => 'Shubhra Sinha Varma',
    uid     => '1159',
    group   => allstaff,
    groups  => ["interns"],
    shell   => '/bin/bash',
    tag     => allstaff,
  }

  @account::user {'mkincaid':
    comment => 'Michael Kincaid',
    uid     => '1160',
    group   => allstaff,
    groups  => ["interns","infra"],
    shell   => '/bin/zsh',
    tag     => allstaff,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAzsbGV53B8L/UPtGgo6YjiotCGulp1ZfS6Zhvr58N/4KxoKmrEOUXSnHGuwJ0XMHeN186XlValWTIMEQTjwpMKmEXZuqNwBd5VPCEQg56RnzuH1iqhAPTzKU2sIEh7Dy7dZGsTXZg7XjKobhZcNbU+z03bmz5uv3RPbpSJMZmxshympPMWhuMWOuuwjH+5HnGZJ1pk1LSYhROc9Ch+gwynjeqAysaz/EMN/EyZDNGd3EofDAX9g1uT3ukTKoPVPn07aS8D3UKN9aMVL/SPwCu5js7VHDQyjXVJ8ePoIfmoypOsHHpF3M3l7WKgTSbUFLKBAufAvrzDfejkAmMqb1jPw==",
    keytype => "ssh-rsa",
  }

  @account::user {'ryan':
    comment => 'Ryan Coleman',
    uid     => '1161',
    group   => allstaff,
    groups  => ["prosvc"],
    shell   => '/bin/bash',
    tag     => allstaff,
    key     => "AAAAB3NzaC1kc3MAAACBAJA99mHspuhsBc/DC7dv+fVtHNqNKqLzgnJo9rPCktXVIL8VWHxgX7e0HaRBMydr1RhCFtIKeXnJnON8pSzkQoZl9N32zRuuWMy/7blFzuXTyKjec8Cp+wnzkBCuB3jLj+jZvjl+4fTItB1R1rtYSoAye0xYwjppiXhEa89TA+OhAAAAFQCCf0vhMbK7pwJY+fvqyhxd3ATbVQAAAIAwmojvpiAPL80bb0twFAwZ0F1cI0iyDTBzQmAFtYMqmMcbZ+TfqRT6h31cFSn8bZWtzhYeCyy0Gukfklkt+0bHb9etUVQbaBrBxqt8Qpc9sH3XliR6yzc/ZWtts5epCRtmvLvT2EyvijZC0cW8ree5iTl5UX7kMj2Pz5EhDpCLcwAAAIB6NdcUgxitfOoAdXtntsWkIZYsuZTRG4YP8ig/9Crse/bBRzFFsr+o/OLiG93Wo4AAl1J9z1M4pFjKxZRpIzKOVWpO0wgNO8gy5W6bc2+BORBOVmdmh1/Zk2lvA1NTZBmfgK1UtSLonZF6MFBrSfNV6Pf4oYMkLNaLUBEJK9GcMg==",
    keytype => "ssh-dss",
  }

  @account::user{'devon':
    comment => 'Devon Harless',
    uid     => '1162',
    group   => 'allstaff',
    groups  => ["developers"],
    shell   => '/bin/bash',
    tag     => 'allstaff',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA/yfuW1BXz6/jjtMAPEK1ZgtqNtY9ZXgzYOOhabn5irkaSxEP6q4kFMHRcWWcr/1dn1MHOV0sARINz/cc1DzhtAAeP+ooRFHFVbfTiaA6dzyU8uyJ0mVYKmwar8j83B/VTxlW1iAKlV//f5dlxghiFgxptFpYvQzetfEtvOtL8IlcJulZwtJojjqvujNk1lG8mK1Ymb5a88wPoBvL0mDoBbtupexH2Zf2zSeqMjp3ex3Po6qvH3dRid6QzniFoO1Vy7PYXDpmmFNaOBoEACTZNlptZC38WIhdhwaDbWxPbYYhwR4uG/kjZVPsvnBDFodwiL5X20aRHAsuSPR4Tf2/Kw==',
    keytype => 'ssh-rsa',
  }

  @account::user{'patrick':
    comment => 'Patrick Carlisle',
    uid     => '1163',
    group   => 'allstaff',
    groups  => ["developers"],
    shell   => '/bin/bash',
    tag     => 'allstaff',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAvawBAbT0tag9cV3idlTCSsX72/mBdFKFqSPqRZ9E6rVNP3V0jpSxPfEyUzVQJXTghR+4J8PdnAPMTpazoOlWQOTptuh25zJffvvWUnyKh/fV/hZSKkwATFXOzl0g570ZQ2Bitgv6vQG7O9l6Md4zNmTp8tzvnXuhmMpCfPqDnzMjdmZo73IpIuUy6vzJL8l6Op4filDAU/UAtS6qD2Kffi3G0T+IArq4uFJldGf3L1SswmOSJmUCsLNg/BFe3WRAJ/6aWni0/+VwXqb0gR/hg1SqrQxxT69E9NPPoDuUGv69HxUDgkvbw7jjAesXbwDUqa23/4FREU1NSoetPhvr/Q==',
    keytype => 'ssh-rsa',
  }

  # (#12008) Release engineering intern
  @account::user{'moses':
    comment => 'Moses Mendoza',
    uid     => '1164',
    group   => 'allstaff',
    groups  => ["developers","release","builder"],
    shell   => '/bin/bash',
    tag     => 'allstaff',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDC+2o3IIBRPPE1iS8OqTvd0A091Utb6XMnIzz7yfgv02N0LyAHbc4vFPPXpt3kORuGTdRuLZ3SOP2VuIiua2eo2kHHKGYKSj7rheRNvbZTuaCXyC9jiLGgA3X+QNHzg33uDK1ygAgyKBWGlJ+CgPsr6tVdLZ4xg/4vJP9eV/Z4DQ6LvENi2pZl1+zDZp9jgEFo3ELNZInhybd52Hy4mKkC6HcgJflRgPf5m05uLT98pjOo/t8/wJ6A98e/p8oVPFT8KCm2EXtXeoq11s1bChR94sig8DFHXiKbfjjkaWz84f+VdoOqltUksicmHAi+DvP4+2VxPN1kOg6Tdoi/eEfz',
    keytype => 'ssh-rsa',
  }
}
