use P_MyBase;
CREATE table ������
([��� �������] nvarchar(50),
[������������ � �������] numeric(6,3),
[��������� ������] money,
constraint ADVERT_TYPE_PK primary key([��� �������])
) on FG1;

CREATE table ���������
([�������� �����] nvarchar(50),
������� nvarchar(40),
��� nvarchar(40),
�������� nvarchar(40),
������� nchar(11),
��� nchar(9),
��� nchar(12),
constraint FIRM_NAME_PK primary key([�������� �����])
)on FG1;

CREATE table ������
([�������� ��������] nvarchar(50),
[�������� �����] nvarchar(50) constraint FIRM_NAME_FK foreign key references ���������([�������� �����]),
[��� �������] nvarchar(50) constraint ADVERT_TYPE_FK foreign key references ������([��� �������]),
���� smalldatetime,
������� tinyint constraint RATE_CHK check(�������>=0 AND �������<=100),
constraint SHOW_NAME_PK primary key([�������� ��������]),
)on FG1;
