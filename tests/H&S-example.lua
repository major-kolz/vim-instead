--$Name: Highlighting and syntax example$
--$Version: 0x01$
--$Author: Николай Коновалов$
-- Не пытайтесь запускать этот файл как игру!

instead_version "2.0.3";
require 'format'              -- Предлагаю использовать одинарные кавычки для "технических строк"

style.constants = {
	username = 'Abeford',
	id = 102,
	isCyborg = false,
	age = 0x19;
}

-- В комментариях отдельно выделяются метки TODO FIXME XXX

main = room {
	nam = "Название комнаты",
	dsc = [["Слова в кавычках"^]] .. " \"Слова в кавычках\"" ..
		[[Ссылки на {xact|объекты} подсвечиваются особым образом: только идентификатор и скобки. Определение допускает использование {talk_to_me(hi)|аргументов} и нижнего подчеркивания. Более того: их можно {talk_to_me(]] .. visited(first_game_room) .. [[)|разрывать между строками}!]] ..
		"Ошибки в ссылках теперь легче отследить: {xactТекст}, {talk to me(txt)|Текст}",
	obj = {
		xact( 'xact', "Обратили внимание как разнятся строки, заключенные в одинарные и обычные кавычки?" ),
		xact( 'talk_to_me', function(s, txt) p(txt) end ),
		'obj1';
	},
};

first = obj{
	var {
		empty = {},						-- Подсветка фигурных скобок работает только в строках, можно не беспокоиться
		do = function(f)				-- Как насчет функций и прочих блоков?
			f()
			local b = {} 
			local c = { {} }
			if f {'is', 'okay', '?'} then
				b = {}
			end
			while false do
				b = {}
			end
			for i, v in ipairs {'some', 'values'} do
				print( i, v )
			end
			funcall( "str", {'one','two',3} )
		end
		seq1 = '\teou\n\t{',
		seq2 = "\toau\n\t{",			-- Подсветка в строках не работает
		seq3 = [[\taoe\n{]];
	},
	dsc = [[В случае, когда {ссылка} представлена одним словом - она подсвечивается целиком, что удобно когда просматриваешь dsc предметов. Можно использовать {"кавычки"}. {Не подсвечено}]],
	act = function(s)
		local onlyCharacters = '{xactid|text}'  -- подсветка ссылок не распространяется на строки в одинарных кавычках
		for field, _ in ipairs(s) do
			print(field)
		end

		if true then 					-- Правильно ли работает подсветка оператора выбора?
			aoeu
		elseif true then 
			aoeu
		else
			aeu
		end
	end,
};

second_game_room = room{
	nam = "Вторая комната",
	dsc = [[Как хорошо видно \"\" экранированные кавычки не подсвечиваются в строках такого формата. Это сделано умышлено, как намек об ошибке (так как экранирование не сработает и кавычки вот так и выведутся).]] .. "Единственная причина, по которой я только \"намекаю\": для выделения другим цветом пришлось бы создавать дополнительное правило, (почти целиком повторяющее это) - а я не хочу плодить сущности.",
	obj = {
		
	}, 
};

-- TODO: 
-- Подсветка luaSpecial (оставить в строках с кавычками, но убрать в многострочных?)
-- Подсветка в забытых запятых/точек с запятой в таблицах
-- :colorsheme writter
