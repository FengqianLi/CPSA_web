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
insert into Analyzer(name, errorId, description, solution) values('GlobalVarSizeAnalyzer', '1.1', 'GlobalVarSizeAnalyzer', 'solution to 1.1');
insert into Analyzer(name, errorId, description, solution) values('ForLoopCombineAnalyzer', '1.2', 'ForLoopCombineAnalyzer', 'solution to 1.2');
insert into Analyzer(name, errorId, description, solution) values('InitializeArrayByForLoopAnalyzer', '1.3', 'InitializeArrayByForLoopAnalyzer', 'solution to 1.3');
insert into Analyzer(name, errorId, description, solution) values('IfToSwitchAnalyzer', '1.4', '代码中含有多重if/else。', '使用switch/case语句代替多重if/else。');
insert into Analyzer(name, errorId, description, solution) values('DivideByTwosExponentAnalyzer', '2.1', 'DivideByTwosExponentAnalyzer', 'solution to 2.1');
insert into Analyzer(name, errorId, description, solution) values('FunctionCallAnalyzer', '2.2', '该函数以\nIf (符合某些条件) {\nDo something\n} else {\nReturn\n}', '我们在调用一个函数以后，进入这个函数的处理，会判断相应的一些条件是否满足，如果不满足则返回。当条件不满足，这个函数的调用开销完全就是在浪费资源。我们为什么不对这些条件进行提前判断呢？如果条件不满足，则不用调用相应的函数了，节省开销。');
insert into Analyzer(name, errorId, description, solution) values('BadMemOperationCallAnalyzer', '2.3', 'BadMemOperationCallAnalyzer', 'solution to 2.3');
insert into Analyzer(name, errorId, description, solution) values('AssignToConstantAnalyzer', '2.4', 'AssignToConstantAnalyzer', 'solution to 2.4');
insert into Analyzer(name, errorId, description, solution) values('ForLoopToZeroAnalyzer', '3.1', 'ForLoopToZeroAnalyzer', 'solution to 3.1');
insert into Analyzer(name, errorId, description, solution) values('SqrtAnalyzer', '3.2', 'SqrtAnalyzer', 'solution to 3.2');
insert into Analyzer(name, errorId, description, solution) values('LoopDivideAnalyzer', '3.3', 'LoopDivideAnalyzer', 'solution to 3.3');
insert into Analyzer(name, errorId, description, solution) values('LocalVarSizeAnalyzer', '3.4', 'LocalVarSizeAnalyzer', 'solution to 3.4');
insert into Analyzer(name, errorId, description, solution) values('MultiplyByTwosExponentAnalyzer', '4.1', 'MultiplyByTwosExponentAnalyzer', 'solution to 4.1');
insert into Analyzer(name, errorId, description, solution) values('RealDivisionAnalyzer', '4.2', 'RealDivisionAnalyzer', 'solution to 4.2');
insert into Analyzer(name, errorId, description, solution) values('MemApplyAnalyzer', '4.3', '在该函数里，存在大量的内存申请释放操作。', '在单个函数处理中，若出现频繁申请释放内存的操作，可以预先申请一大块空间，根据需要，模拟申请释放内存操作。');
insert into Analyzer(name, errorId, description, solution) values('FunctionAsLoopVarAnalyzer', '4.4', 'strlen()函数在for循环中作为循环参数出现', '使用变量代替strlen()函数作为循环参数.');
insert into Analyzer(name, errorId, description, solution) values('StructSizeAnalyzer', '5.1', '该结构体不是4字节对齐的。', '更改结构体成员类型，使其符合4字节对齐，以提升访问速度。');
insert into Analyzer(name, errorId, description, solution) values('BitNotExprAnalyzer', '5.2', 'BitNotExprAnalyzer', 'solution to 5.2');
insert into Analyzer(name, errorId, description, solution) values('StringCopyAnalyzer', '5.3', '使用strcpy/strncpy复制字符串', '用memcpy代替strcpy/strncpy复制字符串。');
insert into Analyzer(name, errorId, description, solution) values('FunctionCodeSizeAnalyzer', '5.4', 'FunctionCodeSizeAnalyzer', 'solution to 5.4');
insert into Analyzer(name, errorId, description, solution) values('GeAndLeCondAnalyzer', '6.1', 'GeAndLeCondAnalyzer', 'solution to 6.1');
insert into Analyzer(name, errorId, description, solution) values('ConditionInLoopAnalyzer', '6.2', '如果循环体内存在逻辑判断，并且循环次数很大，宜将逻辑判断移到循环体的外面。', '将与循环体无关的条件判断放到循环体之外进行。');
insert into Analyzer(name, errorId, description, solution) values('FindSameFunctionAnalyzer', '6.3', '代码中存在另一个函数实现相同功能。', '清理冗余代码');
insert into Analyzer(name, errorId, description, solution) values('MultiConditionAnalyzer', '6.4', 'MultiConditionAnalyzer', 'solution to 6.4');
insert into Analyzer(name, errorId, description, solution) values('FunctionParameterAnalyzer', '7.1', 'FunctionParameterAnalyzer', 'solution to 7.1');
insert into Analyzer(name, errorId, description, solution) values('StructPrmsAnalyzer', '7.2', '使用结构体作为函数的形参或返回值。', '在允许的情况下使用传递指针的方式取代传递结构体变量。');

insert into GroupInfo(name) values('Admin');
insert into GroupInfo(name) values('Manager');

insert into UserInfo(name, password, email, role, gid, active) values('admin', '21232F297A57A5A743894A0E4A801FC3', 'admin@gmail.com', 'admin', 1, true);
