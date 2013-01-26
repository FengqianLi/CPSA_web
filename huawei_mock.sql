drop database if exists huawei;
create database huawei;

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
	description varchar(255),
    unique (name)
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
insert into Analyzer(name, description) values('GlobalVarSizeAnalyzer', 'GlobalVarSizeAnalyzer');
insert into Analyzer(name, description) values('ForLoopCombineAnalyzer', 'ForLoopCombineAnalyzer');
insert into Analyzer(name, description) values('InitializeArrayByForLoopAnalyzer', 'InitializeArrayByForLoopAnalyzer');
insert into Analyzer(name, description) values('IfToSwitchAnalyzer', 'IfToSwitchAnalyzer');
insert into Analyzer(name, description) values('DivideByTwosExponentAnalyzer', 'DivideByTwosExponentAnalyzer');
insert into Analyzer(name, description) values('FunctionCallAnalyzer', 'FunctionCallAnalyzer');
insert into Analyzer(name, description) values('BadMemOperationCallAnalyzer', 'BadMemOperationCallAnalyzer');
insert into Analyzer(name, description) values('AssignToConstantAnalyzer', 'AssignToConstantAnalyzer');
insert into Analyzer(name, description) values('ForLoopToZeroAnalyzer', 'ForLoopToZeroAnalyzer');
insert into Analyzer(name, description) values('SqrtAnalyzer', 'SqrtAnalyzer');
insert into Analyzer(name, description) values('LoopDivideAnalyzer', 'LoopDivideAnalyzer');
insert into Analyzer(name, description) values('LocalVarSizeAnalyzer', 'LocalVarSizeAnalyzer');
insert into Analyzer(name, description) values('MultiplyByTwosExponentAnalyzer', 'MultiplyByTwosExponentAnalyzer');
insert into Analyzer(name, description) values('RealDivisionAnalyzer', 'RealDivisionAnalyzer');
insert into Analyzer(name, description) values('MemApplyAnalyzer', 'MemApplyAnalyzer');
insert into Analyzer(name, description) values('FunctionAsLoopVarAnalyzer', 'FunctionAsLoopVarAnalyzer');
insert into Analyzer(name, description) values('StructSizeAnalyzer', 'StructSizeAnalyzer');
insert into Analyzer(name, description) values('BitNotExprAnalyzer', 'BitNotExprAnalyzer');
insert into Analyzer(name, description) values('StringCopyAnalyzer', 'StringCopyAnalyzer');
insert into Analyzer(name, description) values('FunctionCodeSizeAnalyzer', 'FunctionCodeSizeAnalyzer');
insert into Analyzer(name, description) values('GeAndLeCondAnalyzer', 'GeAndLeCondAnalyzer');
insert into Analyzer(name, description) values('ConditionInLoopAnalyzer', 'ConditionInLoopAnalyzer');
insert into Analyzer(name, description) values('FindSameFunctionAnalyzer', 'FindSameFunctionAnalyzer');
insert into Analyzer(name, description) values('MultiConditionAnalyzer', 'MultiConditionAnalyzer');
insert into Analyzer(name, description) values('FunctionParameterAnalyzer', 'FunctionParameterAnalyzer');
insert into Analyzer(name, description) values('StructPrmsAnalyzer', 'StructPrmsAnalyzer');

insert into GroupInfo(name) values('Manager');
insert into GroupInfo(name) values('Compiler Group');
insert into GroupInfo(name) values('Test Tool Group');
insert into GroupInfo(name) values('Network Group');
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

