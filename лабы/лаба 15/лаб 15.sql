--1
/*����������� �������� �������� XML-��������� � ������ PATH �� ������� TEACHER ��� �������������� ������� ����. */
select PULPIT.FACULTY[���������], TEACHER.PULPIT[���������/�������], 
TEACHER.TEACHER_NAME[���������/�������/�������������]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = '����' for xml raw, root('������_��������������_�������_����');

select PULPIT.FACULTY[���������], TEACHER.PULPIT[���������/�������], 
TEACHER.TEACHER_NAME[���������/�������/�������������]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = '����' for xml path, root('������_��������������_�������_����');

--2
/*����������� �������� �������� XML-��������� � ������ AUTO �� ������ SELECT-������� � �������� AUDITORIUM � AUDITORIUM_TYPE, 
������� �������� ��������� �������:
������������ ���������, ������������ ���� ��������� � �����������. 
����� ������ ���������� ���������*/

select AUDITORIUM.AUDITORIUM [���������], AUDITORIUM.AUDITORIUM_TYPE [�������������_����],
AUDITORIUM.AUDITORIUM_CAPACITY [�����������] 
from AUDITORIUM 
join AUDITORIUM_TYPE on AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE
where AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '����������'
for xml auto, type, root('������_���������')
--3
/*����������� XML-��������, ���������� ���-��� � ���� ����� ������� �����������, ����-��� ������� �������� � ������� SUBJECT. 
����������� ��������, ����������� ������ � ����������� �� XML-��������� � �������-���� �� � ������� SUBJECT. 
��� ���� ��������� ��������� ������� OPENXML � ����������� INSERT� SELECT. 
*/
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <����������>
					     <���������� ���="�" ��������="���" �������="����" />
						 <���������� ���="��" ��������="�" �������="����" />
						 <���������� ���="�" ��������="��������������" �������="����" />
					  </����������>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[���], [��������], [�������] from openxml (@h, '/����������/����������',0)
with([���] char(10), [��������] varchar(100), [�������] char(20));

select * from SUBJECT
--delete from SUBJECT where SUBJECT.SUBJECT='����' or SUBJECT.SUBJECT='���' or SUBJECT.SUBJECT='���'

--4
/*��������� ������� STUDENT ����������� XML-���������, ���������� ���������� ���-��� ��������: ����� � ����� ��������, ������ �����, ���� ������ � ����� ��������. 
����������� ��������, � ������� ������� �������� INSERT, ����������� ������ � XML-��������.
�������� � ���� �� �������� �������� UP-DATE, ���������� ������� INFO � ����� ������ ������� STUDENT � �������� SELECT, ����������� �������������� �����, ����������� ��������������� �� ��-�����. 
� SELECT-������� ������������ ������ QUERY � VALUEXML-����.
*/
insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
values(4, '�������� �.�.', '2002-07-17',
	'<�������>
		<������� �����="��" �����="1111111" ����="2018-03-12" />
		<�������>+375295056451</�������>
		<�����>
			<������>��������</������>
			<�����>�����</�����>
			<�����>���������</�����>
			<���>14</���>
			<��������>105</��������>
		</�����>
	</�������>');
select * from STUDENT where NAME = '�������� �.�.';
update STUDENT set INFO = '<�������>
		<������� �����="��" �����="0000000" ����="2018-03-12" />
		<�������>37529589565</�������>
		<�����>
			<������>��������</������>
			<�����>�����</�����>
			<�����>���������</�����>
			<���>12</���>
			<��������>�</��������>
		</�����>
	</�������>' where NAME='�������� �.�.'
select NAME[���], INFO.value('(�������/�������/�����)[1]', 'char(2)')[����� ��������],
INFO.value('(�������/�������/�����)[1]', 'varchar(20)')[����� ��������], 
INFO.query('/�������/�����')[�����]
from  STUDENT where NAME = '�������� �.�.';   

--5
/*�������� (ALTER TABLE) ������� STUDENT � ���� ������ UNIVER ����� �������, ����� �������� ��������������� ������� � ������ INFO ���������������� ���������� XML-���� (XML SCHEMACOLLECTION), ����-���������� � ������ �����. 
����������� ��������, ��������������� ���� � ������������� ������ (��������� IN-SERT � UPDATE) � ������� INFO ������� STUDENT, ��� ���������� ������, ��� � ����������.
����������� ������ XML-����� � �������� �� � ��������� XML-���� � �� UNIVER
*/

create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

--alter table STUDENT alter column INFO xml(Student);
--drop XML SCHEMA COLLECTION Student;
select Name, INFO from STUDENT where NAME='�������� �.�.'