drop database if exists huawei;
create database huawei;

CHARACTER SET utf8
DEFAULT CHARACTER SET utf8
COLLATE utf8_general_ci
DEFAULT COLLATE utf8_general_ci;
       
use huawei;

create table GroupInfo(
	gid int not null primary key auto_increment,
	name varchar(255) not null,
    unique (name)
)default charset=utf8 TYPE=InnoDB;

create table UserInfo(
	uid int not null primary key auto_increment,
	name varchar(255) not null,
    password varchar(255) not null,
	email varchar(255),
	gid int,        -- group id
	role enum('member', 'leader', 'manager', 'admin') default 'member',   -- default value is member and can be changed in the admin web page
	active bool default false,
	foreign key (gid) references GroupInfo(gid),
    unique (email),
    unique (name)
)default charset=utf8 TYPE=InnoDB;

create table Project(
	pid int not null primary key auto_increment,
	name varchar(255) not null,
	description varchar(255),
	gid int not null,                  -- the group this project belongs to
	ownerId int not null,			-- the user submitting this project
	visible bool default false,
	foreign key (gid) references GroupInfo(gid),
	foreign key (ownerId) references UserInfo(uid) ON DELETE CASCADE,
    unique (name, gid)
)default charset=utf8 TYPE=InnoDB;

create table Analyzer(
	aid int not null primary key auto_increment,
	name varchar(255) not null,
    errorId varchar(255) not null,
	description varchar(255),
    solution varchar(255) not null,
    unique (name),
    unique (errorId)
)default charset=utf8 TYPE=InnoDB;

create table Submit(
	sid int not null primary key auto_increment,
	uid int not null,                           -- submit user
	pid int not null,                           -- submit project
	analyzers varchar(256) not null,
	_time timestamp not null,                   -- submit time
	description varchar(255) not null,
	status bool default false,
	foreign key (uid) references UserInfo(uid) ON DELETE CASCADE,
	foreign key (pid) references Project(pid) ON DELETE CASCADE
)default charset=utf8 TYPE=InnoDB;

create table FindPassword(
	url varchar(255) not null primary key,
	uid int not null,
	active bool default true,
	_time timestamp not null,
	foreign key(uid) references UserInfo(uid) ON DELETE CASCADE
)default charset=utf8 TYPE=InnoDB;

create table SubmitFile(
	sid int not null,
	name varchar(255) not null,            -- Submit file name
	error_num int default -1,      -- Total errors of this file, default number is -1 means hasn't been analyzed
	primary key(sid, name),
	foreign key (sid) references Submit(sid) ON DELETE CASCADE
)default charset=utf8 TYPE=InnoDB;

create table PrjFile(
	pid int not null,
	name varchar(255) not null,
	primary key(pid, name),
	foreign key (pid) references Project(pid) ON DELETE CASCADE
)default charset=utf8 TYPE=InnoDB;

create table AnalyzeResult(
	sid int not null,              -- Submit ID
	fileName varchar(255) not null,   -- File Name
	aid int not null,     -- Analyzer ID
	error_num int not null,        -- Error numbers of this submit, file and analyzer
	primary key (sid, fileName, aid),
	foreign key (aid) references Analyzer(aid)
)default charset=utf8 TYPE=InnoDB;


-- insert the analyzer infomations
insert into Analyzer(name, errorId, description, solution) values('GlobalVarSizeAnalyzer', '1.1', '全局变量和局部变量不同，只有在程序运行结束以后才能释放。因此在有些条件下全局变量的大小如能保持在一个范围之内程序的健壮性会更好。', '修改全局变量的定义，尽可能把全局变量变为局部变量。');
insert into Analyzer(name, errorId, description, solution) values('ForLoopCombineAnalyzer', '1.2', '当两个连续for循环可以合并，可以减少对于index变量的操作，从而减少了程序所需运行的时钟周期。', '合并两个循环语句。');
insert into Analyzer(name, errorId, description, solution) values('InitializeArrayByForLoopAnalyzer', '1.3', '使用循环初始化数组元素', '当数组成员默认初始化为清零或其它特定模式时，如果循环较长，考虑是否可以使用memset操作替代循环初始化');
insert into Analyzer(name, errorId, description, solution) values('IfToSwitchAnalyzer', '1.4', '代码中含有多重if/else。', '使用switch/case语句代替多重if/else。');
insert into Analyzer(name, errorId, description, solution) values('DivideByTwosExponentAnalyzer', '2.1', '常数乘法，除法操作数是2的幂', '数乘除法操作数是2的幂次时请使用bit移位运算，节约指令周期');
insert into Analyzer(name, errorId, description, solution) values('FunctionCallAnalyzer', '2.2', '调用频繁且大多数正常业务流程下进入的这个函数会马上return，如果有主要的条件可以判断是否能进入改函数。', '将这个函数中条件判断部分提取到调用这个函数之前部分，减少不必要的函数调用开销。');
insert into Analyzer(name, errorId, description, solution) values('BadMemOperationCallAnalyzer', '2.3', '用memset设置POD类型变量内容', 'memset的第一个参数如果是POD类型，考虑使用变量模版赋值或是常量赋值替代memset，较少函数调用开销');
insert into Analyzer(name, errorId, description, solution) values('AssignToConstantAnalyzer', '2.4', '变量赋值为常量', '如果使用变量保存常量内容，之后实际一直使用此常量，可以考虑把此常量定义为宏，在使用处直接使用此宏');
insert into Analyzer(name, errorId, description, solution) values('ForLoopToZeroAnalyzer', '3.1', '和0的比较判断与和其他数的比较判断相比少了一次减操作，所以减少了时钟周期。', '将从0到n的循环改为从n到0');
insert into Analyzer(name, errorId, description, solution) values('SqrtAnalyzer', '3.2', 'SqrtAnalyzer', 'solution to 3.2');
insert into Analyzer(name, errorId, description, solution) values('LoopDivideAnalyzer', '3.3', '循环体中代码量较多', '考虑展开此循环。');
insert into Analyzer(name, errorId, description, solution) values('LocalVarSizeAnalyzer', '3.4', '如果局部变量的大小超过512字节，将其改为全局变量或者静态分配的内存更加合适，因为堆栈的大小有限。', '将此局部变量改为全局变量或者静态变量。');
insert into Analyzer(name, errorId, description, solution) values('MultiplyByTwosExponentAnalyzer', '4.1', '常数乘法，乘法操作数是2的幂', '常数乘法操作数是2的幂次时请使用bit以为运算，节约指令周期');
insert into Analyzer(name, errorId, description, solution) values('RealDivisionAnalyzer', '4.2', 'RealDivisionAnalyzer', 'solution to 4.2');
insert into Analyzer(name, errorId, description, solution) values('MemApplyAnalyzer', '4.3', '在该函数里，存在大量的内存申请释放操作。', '在单个函数处理中，若出现频繁申请释放内存的操作，可以预先申请一大块空间，根据需要，模拟申请释放内存操作。');
insert into Analyzer(name, errorId, description, solution) values('FunctionAsLoopVarAnalyzer', '4.4', 'strlen()函数在for循环中作为循环参数出现', '使用变量代替strlen()函数作为循环参数.');
insert into Analyzer(name, errorId, description, solution) values('StructSizeAnalyzer', '5.1', '该结构体不是4字节对齐的。', '更改结构体成员类型，使其符合4字节对齐，以提升访问速度。');
insert into Analyzer(name, errorId, description, solution) values('BitNotExprAnalyzer', '5.2', 'BitNotExprAnalyzer', 'solution to 5.2');
insert into Analyzer(name, errorId, description, solution) values('StringCopyAnalyzer', '5.3', '使用strcpy/strncpy复制字符串', '用memcpy代替strcpy/strncpy复制字符串。');
insert into Analyzer(name, errorId, description, solution) values('FunctionCodeSizeAnalyzer', '5.4', '当函数有效代码太短时可以通过将它转化为宏来减小函数调用的开支', '将函数转化为宏');
insert into Analyzer(name, errorId, description, solution) values('GeAndLeCondAnalyzer', '6.1', '条件判断中同时存在x大于等于某个数并且小于等于某个数时可以将其优化', '将此条件判断改为x-min>=0并且x-max<=0');
insert into Analyzer(name, errorId, description, solution) values('ConditionInLoopAnalyzer', '6.2', '如果循环体内存在逻辑判断，并且循环次数很大，宜将逻辑判断移到循环体的外面。', '将与循环体无关的条件判断放到循环体之外进行。');
insert into Analyzer(name, errorId, description, solution) values('FindSameFunctionAnalyzer', '6.3', '代码中存在另一个函数实现相同功能。', '清理冗余代码');
insert into Analyzer(name, errorId, description, solution) values('MultiConditionAnalyzer', '6.4', '条件判断时出现大于等于三个的条件判断同时存在', '提示将多个条件判断中概率最高的条件放在最前面。（也可能不需要调整）');
insert into Analyzer(name, errorId, description, solution) values('FunctionParameterAnalyzer', '7.1', '函数参数过多', '将函数参数减少');
insert into Analyzer(name, errorId, description, solution) values('StructPrmsAnalyzer', '7.2', '使用结构体作为函数的形参或返回值。', '在允许的情况下使用传递指针的方式取代传递结构体变量。');

insert into GroupInfo(name) values('Manager');
insert into GroupInfo(name) values('Compiler_Group');
insert into GroupInfo(name) values('Test_Tool_Group');
insert into GroupInfo(name) values('Network_Group');
insert into GroupInfo(name) values('Admin');

insert into UserInfo(name, password, email, role, gid, active) values('lfq', 'E10ADC3949BA59ABBE56E057F20F883E', 'lfq@gmail.com', 'member', 2, true);
insert into UserInfo(name, password, email, role, gid, active) values('yangyi', 'E10ADC3949BA59ABBE56E057F20F883E', 'yy@gmail.com', 'leader', 2, true);
insert into UserInfo(name, password, email, role, gid, active) values('shenyao', 'E10ADC3949BA59ABBE56E057F20F883E', 'yshen@gmail.com', 'manager', 1, true);
insert into UserInfo(name, password, email, role, gid, active) values('tangxiaoxin', 'E10ADC3949BA59ABBE56E057F20F883E', 'txx@gmail.com', 'member', 3, true);
insert into UserInfo(name, password, email, role, gid, active) values('chenheng', 'E10ADC3949BA59ABBE56E057F20F883E', 'ch@gmail.com', 'member', 2, true);
insert into UserInfo(name, password, email, role, gid, active) values('lizhao', 'E10ADC3949BA59ABBE56E057F20F883E', 'lz@gmail.com', 'member', 4, true);
insert into UserInfo(name, password, email, role, gid, active) values('admin', '21232F297A57A5A743894A0E4A801FC3', 'admin@gmail.com', 'admin', 5, true);

insert into Project(name, description, ownerId, gid, visible) values('analyzer', 'Huawei Static Code Performace Analyzer', 2, 2, true);
insert into Project(name, description, ownerId, gid, visible) values('test', 'test my code performance', 2, 2, false);
insert into Project(name, description, ownerId, gid, visible) values('chazhuang', 'Huawei chazhuang Tool', 4, 3, true);
insert into Project(name, description, ownerId, gid, visible) values('webqq', 'my web qq  j2ee project', 1, 2, false);
insert into Project(name, description, ownerId, gid, visible) values('openflow', 'tencent openflow project', 3, 4, true);
insert into Project(name, description, ownerId, gid, visible) values('test', 'test my algorithm code performence', 3, 1, false);

insert into Submit(uid, pid, analyzers, _time, description, status) values(2, 1, '11111111111111111111111111', 20121004120503, 'init huawei static code performance analyzer', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(2, 2, '11111111111111111111111111', 20121005032101, 'test my code performance', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(4, 3, '11111111111111111111111111', 20121010071201, 'init huawei chazhuang project', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(1, 4, '11111111111111111111111111', 20121010092329, 'init my private web qq project', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(3, 5, '11111111111111111111111111', 20121011092329, 'init tencent openflow project', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(3, 6, '11111111111111111111111111', 20121012232902, 'test my private algorithm code performance', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(1, 4, '11111111111111111111111111', 20121013092029, 'update my web qq', true);
insert into Submit(uid, pid, analyzers, _time, description, status) values(1, 4, '11111111111111111111111111', 20121013102029, 'update my web qq again', true);

insert into SubmitFile(sid, name, error_num) values(1, './a.cpp', 5);
insert into SubmitFile(sid, name, error_num) values(1, './b.cpp', 3);
insert into SubmitFile(sid, name, error_num) values(1, './a', 7);
insert into SubmitFile(sid, name, error_num) values(1, './a/a.cpp', 3);
insert into SubmitFile(sid, name, error_num) values(1, './a/b.cpp', 4);
insert into SubmitFile(sid, name, error_num) values(2, './a.cpp', 5);
insert into SubmitFile(sid, name, error_num) values(3, './a.cpp', 4);
insert into SubmitFile(sid, name, error_num) values(4, './a.cpp', 3);
insert into SubmitFile(sid, name, error_num) values(5, './a.cpp', 2);
insert into SubmitFile(sid, name, error_num) values(6, './a.cpp', 1);
insert into SubmitFile(sid, name, error_num) values(7, './a.cpp', 1);
insert into SubmitFile(sid, name, error_num) values(8, './a.cpp', 3);


insert into PrjFile(pid, name) values(1, './a.cpp');
insert into PrjFile(pid, name) values(1, './b.cpp');
insert into PrjFile(pid, name) values(1, './a');
insert into PrjFile(pid, name) values(1, './a/a.cpp');
insert into PrjFile(pid, name) values(1, './a/b.cpp');
insert into PrjFile(pid, name) values(2, './a.cpp');
insert into PrjFile(pid, name) values(3, './a.cpp');
insert into PrjFile(pid, name) values(4, './a.cpp');
insert into PrjFile(pid, name) values(5, './a.cpp');
insert into PrjFile(pid, name) values(6, './a.cpp');

insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './a.cpp', 1, 3);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './a.cpp', 7, 2);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './b.cpp', 3, 1);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './b.cpp', 2, 1);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './b.cpp', 12, 1);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './a/a.cpp', 8, 2);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './a/a.cpp', 12, 1);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './a/b.cpp', 20, 2);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(1, './a/b.cpp', 17, 2);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(2, './a.cpp', 2, 5);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(3, './a.cpp', 3, 4);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(4, './a.cpp', 4, 3);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(5, './a.cpp', 5, 2);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(6, './a.cpp', 6, 1);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(7, './a.cpp', 9, 1);
insert into AnalyzeResult(sid, fileName, aid, error_num) values(8, './a.cpp', 10, 3);

