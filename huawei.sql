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

insert into GroupInfo(name) values('Admin');
insert into GroupInfo(name) values('Manager');

insert into UserInfo(name, password, email, role, gid, active) values('admin', '21232F297A57A5A743894A0E4A801FC3', 'admin@gmail.com', 'admin', 1, true);
