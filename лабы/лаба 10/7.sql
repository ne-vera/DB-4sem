use P_MyBase
go

declare @str char(20), @out varchar(300)=''
declare expen cursor 
			for (select ������.[��� �������] from ������
					where ������.[��������� ������]>900)
	open expen;
	fetch expen into @str
	print '������ ������ 900'
	while @@FETCH_STATUS = 0
		begin
			set @out = rtrim(@str) + ', ' + @out;
			fetch expen into @str;
		end;
	print @out;
close expen
deallocate expen