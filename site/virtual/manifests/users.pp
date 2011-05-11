class virtual::users {
  include virtual::groups
  include virtual::users::customers
  include virtual::users::external

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
    group   => allstaff,
    groups  => ["prosvc"],
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
    groups  => ["sysadmin","operations"],
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
    shell   => '/bin/bash',
    group   => allstaff,
    groups  => ["sysadmin","operations"],
    tag     => allstaff,
 }

 @account::user {'djm':
    comment => 'Dominic Maraglia',
    uid     => '1124',
    group   => allstaff,
    groups  => ["developers"],
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
    groups  => ["developers"],
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6viS8/Dpm60UgXz43DBh6OdhY3hGylhewlVsllOJEOBJagLn6OG0VPGUKSCfVT86Qi7qz8wzvtR9BsmzQkd4mxgW0YcRD8AO4o65m8F6jfbTnMHWDw593cK6CLWXErNApRDZJ+cApfRZegUi/B0V984OFDBZqO4V90IEa4LNYSrwFV8nkTMBjvh0h/9SNB1tk1zJj0wzV5w4JPCGr0pFWIYLnaX2C7wDPAD/Ti5lUBaNlyUi2v4WUf5F7wA8rzuV+8lEUrUiYKzUeA2PY9kCRhMgXJhBeerztS12j0w0Gt7AxfFNtIwjByxc17Av0lF5X+Nb3NeO/wJ85sD87VVRxQ==',
    tag     => allstaff,
 }
 
 @account::user {'ben':
    comment => 'Ben Hughes',
    uid     => '1025',
    group   => allstaff,
    shell   => '/bin/zsh',
    groups  => ["sysadmin","operations"],
    tag     => allstaff,
 }
 
 @account::user {'ken':
    comment => 'Ken Barber',
    uid     => '1142',
    group   => allstaff,
    groups  => ["prosvc"],
    shell   => '/bin/bash',
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEA04dOEngfuA7phW/0yWH/gBV11udAGvuUhClyuuA3n6MRxYnSei8JBtTFeGNjgKRsxSqv5rTf9HnIHTC5ECMhnjV3bUYdRxs76RlFghYpldBgDEDurgZZgzZWsUALkLwMXH+CzQ7bY/UeYa8gOt/XfjewhL/BStmlJ2/DiFychKP+BoxrIxv3p7tdM9yvaUviLoomD9rEZzT+3bvSloVWo2lh9Q8LcexuZUnLTKA5C4gCk6mq8PutU/Non3NCZaOUntTN7qvk+NIMGxxXFzYIDDP3c61Cwq/z0PshHAcWVHganNxEdNFhfPt+E7SGVeGHAoHgXnTsX4bYKeClMnz8nQ==",
    keytype => "ssh-rsa",
    tag     => allstaff,
 }
 
 @account::user {'adrien':
    comment => 'Adrien Thebo',
    uid     => '1026',
    group   => allstaff,
    groups  => ["interns"],
    shell   => '/bin/bash',
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAr/PYSBs0degY8/NxTZAsidGG+9Wnqb6RQxqm+HRK+Jc4toetKOvXVfwCKQczTwpuKlS3bT0MREv2Ur4boFm7jWGy01y0cJBLjBQEsefWjb3jlQIuYZcaYBlzSq1PlzeuTHcc86k34gvL0uKojYmc43kX/ao3o3yIp4/7SlKJVpYikWNB0NDOokeGEr440GwAGUzybgur/Vfm+aYa9k0wigCC386S1/l4MQ3dDI8D83fOZnyHVOmyjBFL/Nz2Q3Xy4P/Sey8g40SoO4UjNtGmZRmwmdUaF1p1i1BDW7wqsFBYwKeLKv8ZjNo+zy0Mflm2KFnrHBd1FOzymYV3g1biyw==",
    keytype => "ssh-rsa",
    tag     => allstaff,
 }

#
# Service accounts
#
 @account::user { 'deploy':
    comment => 'Deployment User',
    group   => www-data,
    tag     => deploy,
 }

 @account::user { 'git':
    comment => 'Git User',
    group   => git,
    tag     => git,
 }

 @account::user { 'hudson':
    comment => 'Hudson User',
    group   => hudson,
    tag     => hudson,
 }

 @account::user { 'patchwork':
    comment => 'Patchwork User',
    usekey  => false,
    group   => patchwork,
    tag     => patchwork,
 }

 @account::user { 'osqa':
    comment => 'OSQA User',
    usekey  => false,
    group   => osqa,
    tag     => osqa,
 }

}
