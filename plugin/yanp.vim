" YANP
"
" Notetaking plugin that supports recurring topics structure and 
" customisable syntax.
"
" Created and currently maintained by boson joe.
" https://github.com/boson-joe
"
" ':h YANPLicense' in Vim or open the 'license.txt' file in the root
" directory of this plugin to read the license this software is distributed on.
"
" ':h yanp' in Vim or go to the link below to view the general information.
" https://github.com/boson-joe/YANP/wiki



" ---------- Guards

if exists("g:YANP_plugin_is_loaded")
    finish
endif

if !exists("s:YANP_source_count")
    let s:YANP_source_count = 0
    let s:YANP_max_sources  = 2
endif

if s:YANP_source_count == 0
    let g:YANP_version = 100
endif



" ---------- YANP default mappings.

if s:YANP_source_count  == 0

if !hasmapto('<Plug>YanpRegularFile', 'nv') && (mapcheck('<leader>yr') == '')
    :nmap <leader>yr <Plug>YanpRegularFile
    :vmap <leader>yr <Plug>YanpRegularFile
endif

if !hasmapto('<Plug>YanpImage', 'nv') && (mapcheck('<leader>yi') == '')
    :nmap <leader>yi <Plug>YanpImage
    :vmap <leader>yi <Plug>YanpImage
endif

if !hasmapto('<Plug>YanpIndexFile', 'nv') && (mapcheck('<leader>yd') == '')
    :nmap <leader>yd <Plug>YanpIndexFile
    :vmap <leader>yd <Plug>YanpIndexFile
endif

if !hasmapto('<Plug>YanpSelectedPath', 'nv') && (mapcheck('<leader>ys') == '')
    :nmap <leader>ys <Plug>YanpSelectedPath
    :vmap <leader>ys <Plug>YanpSelectedPath
endif

if !hasmapto('<Plug>YanpFastNote', 'nv') && (mapcheck('<leader>yf') == '')
    :nmap <leader>yf <Plug>YanpFastNote
    :vmap <leader>yf <Plug>YanpFastNote
endif

if !hasmapto('<Plug>YanpMainIndex', 'nv') && (mapcheck('<leader>ym') == '')
    :nmap <leader>ym <Plug>YanpMainIndex
    :vmap <leader>ym <Plug>YanpMainIndex
endif

if !hasmapto('<Plug>YanpLastIndex', 'nv') && (mapcheck('<leader>yl') == '')
    :nmap <leader>yl <Plug>YanpLastIndex
    :vmap <leader>yl <Plug>YanpLastIndex
endif

if !hasmapto('<Plug>YanpNewFile', 'nv') && (mapcheck('<leader>yn') == '')
    :nmap <leader>yn <Plug>YanpNewFile
    :vmap <leader>yn <Plug>YanpNewFile
endif

if !hasmapto('<Plug>YanpUpdate', 'nv') && (mapcheck('<leader>yu') == '')
    :nmap <leader>yu <Plug>YanpUpdate
    :vmap <leader>yu <Plug>YanpUpdate
endif

endif



" ---------- YANP customization

if s:YANP_source_count  == 1

let s:YANP_extention 
    \= get(g:, 'YANP_extention', s:YANP_extention_DEF)

let s:YANP_index_page 
    \= get(g:, 'YANP_index_page', s:YANP_index_page_DEF)

let s:YANP_index_page_name 
    \= s:YANP_index_page..s:YANP_extention

let s:YANP_main_directory  
    \= get(g:, "YANP_main_directory", s:YANP_main_directory_DEF)

let s:YANP_fast_note_dir_name 
    \= get(g:, "YANP_fast_note_dir_name", s:YANP_fast_note_dir_name_DEF) 

let s:YANP_fast_notes_dir  
    \= s:YANP_main_directory .. '/' .. s:YANP_fast_note_dir_name

let s:YANP_fast_note_name_format 
    \= get(g:, "YANP_fast_note_name_format", s:YANP_fast_note_name_format_DEF)

let s:YANP_path_is_absolute
    \= get(g:, "YANP_path_is_absolute", 0)

" These should be public, so syntax plugin can redefine it.    
let g:YANP_GetRegularLinkToThis 
    \= get(g:, 'YANP_GetRegularLinkToThis', function('<SID>YANP_GetRegularLinkToThis_DEF'))


" These should be limited to the script scope.
let s:YANP_GetDictPathForRegFile 
    \= get(g:, 'YANP_GetDictPathForUrl', function('<SID>YANP_GetDictPathForRegFile_DEF'))

let s:YANP_GetDictPathForImg 
    \= get(g:, 'YANP_GetDictPathForImg', function('<SID>YANP_GetDictPathForImg_DEF'))

let s:YANP_GetPathForIndexFile 
    \= get(g:, 'YANP_GetPathForIndexFile', function('<SID>YANP_GetPathForIndexFile_DEF'))

let s:YANP_EditFastNote = 
    \get(g:, "YANP_EditFastNote", function("<SID>EditFileInPreviewWin"))

endif



" ---------- YANP defaults

if s:YANP_source_count  == 0

let s:YANP_extention_DEF            = '.yanp'
let s:YANP_index_page_DEF           = 'index'
let s:YANP_main_directory_DEF       = expand('~') .. '/YANP'
let s:YANP_fast_note_dir_name_DEF   = 'Fast_Notes'
let s:YANP_fast_note_name_format_DEF= "%d.%m.%Y"

function! YANP_CorrectPathIfNeeded(path)
    if !s:YANP_path_is_absolute
        return substitute(a:path, "/\\a\\+/\\a\\+/", "~/", "")
    else
        return a:path
    endif
endfunction

function! s:YANP_GetDictPathForRegFile_DEF(...)
    let l:path = expand("%:p:h")
    return YANP_CorrectPathIfNeeded(l:path)
endfunction

function! s:YANP_GetDictPathForImg_DEF(...)
    return <SID>YANP_GetDictPathForRegFile_DEF() .. '/Img'
endfunction

function! s:YANP_GetPathForIndexFile_DEF(i_name)
    return <SID>YANP_GetDictPathForRegFile_DEF() .. 
                \'/' .. a:i_name .. '/' .. s:YANP_index_page_name
endfunction

" The function below fire -1. 
" In case syntax plugin does not redefine it.
function! s:YANP_GetRegularLinkToThis_DEF(this)
    echoerr "YanpError - Your syntax plugin didn't redefine".. 
           \"YANP_GetRegularLinkToThis() function!"
    return -1
endfunction

endif



" ---------- User Interface

if s:YANP_source_count  == 1
    nnoremap <Plug>YanpMainIndex    :YANPOpenMainIndex<cr> 
    nnoremap <Plug>YanpLastIndex    :YANPOpenLastIndex<cr> 
    nnoremap <Plug>YanpFastNote     :YANPOpenTodayFastNote<cr> 
    nnoremap <Plug>YanpNewFile      :YANPOpenNewFile<cr> 
    nnoremap <Plug>YanpUpdate       :YANPUpdate<cr> 
endif

if s:YANP_source_count  == 0
    command! YANPOpenMainIndex eval s:open_index_action.Instance().OpenMainIndex()  
    command! YANPOpenLastIndex eval s:open_index_action.Instance().OpenLastIndex()
    command! YANPOpenTodayFastNote eval <SID>OpenFastNote()
    command! YANPOpenNewFile   eval s:open_index_action.Instance().OpenNewFile()
    command! YANPUpdate        eval s:yanp_updater.Instance().Update()

function! s:OpenFastNote()
    if !exists('s:fast_note')
        " this one is not done through singleton pattern for purpose.
        let s:fast_note = s:fast_note_action.New(s:fast_note_creator.New())
    endif

    eval s:fast_note.MakeAction()
endfunction

endif



" ---------- OOP module

" General Object Functions

if s:YANP_source_count  == 0

function! s:Inherit(parent, ...)
    let l:new_class = deepcopy(a:parent)
    if len(a:000) != 0
        for [k,V] in items(a:1)
            let l:new_class[k] = V
        endfor
    endif
    return l:new_class
endfunction

function! s:VIRTUAL_FUN(...) dict
    return 0
endfunction

endif



" --------- YANP objects

" START - Mediator class 
if s:YANP_source_count == 1
let s:mediator_for_syntax = 
\{
    \'class_name'           :'mediator_for_syntax',
    \'unique_instance'      :{},
    \'observers'            :0,
    \'subjects'             :0,
    \'subjects_saved_states':0,
    \'correct_keys'         : 
        \{
            \'Regular':'reg', 'Image':'img', 'Index':'dict', 'Selective': 'sel'
        \},
    \'Instance'             :function('<SID>ORInstance'),
    \'GetCorrectKey'        :function('<SID>ORGetCorrectKey'),
    \'RegisterAsObserver'   :0,
    \'UnregisterObserver'   :0,
    \'NotifyObserver'       :0,
    \'RegisterAsSubject'    :0,
    \'UnregisterSubject'    :0,
    \'SubjectAction'        :0,
    \'SaveState'            :0,
    \'GetState'             :0,
\}
endif

if s:YANP_source_count == 0

function! s:ORRegisterAsObserver(observer) dict
    let self.observers[a:observer.file_creator.registry_key] = a:observer
    let a:observer.registry = self
endfunction

function! s:ORUnregisterObserver(observer) dict
    let l:key = a:observer.file_creator.registry_key
    if has_key(self.observers, l:key)
        let self.observers[l:key].registry = 0
        let self.observers[l:key]          = 0
    endif
endfunction

function! s:ORNotifyObserver(file_type_name) dict
    if has_key(self.observers, a:file_type_name)
        eval self.observers[a:file_type_name].Update()
    else
        return 0
    endif
    return 1
endfunction

function! s:ORRegisterAsSubject(subject) dict
    let self.subjects[a:subject.registry_key] = a:subject
    let a:subject.registry = self
endfunction

function! s:ORUnregisterSubject(subject) dict
    let l:key = a:subject.registry_key
    if has_key(self.subjects, l:key)
        let self.subjects[l:key].registry = 0
        let self.subjects[l:key]          = 0
    endif
endfunction

function! s:ORSubjectAction(file_type_name) dict
    if has_key(self.subjects, a:file_type_name)
        let l:subject = self.subjects[a:file_type_name]
        eval l:subject.SaveState(l:subject.GetState())
        eval l:subject.Notify()
    endif
endfunction

function! s:ORSaveState(state, file_type_name) dict
    let self.subjects_saved_states[a:file_type_name] = a:state
endfunction

function! s:ORGetState(file_type_name) dict
    if has_key(self.subjects_saved_states, a:file_type_name)
        return self.subjects_saved_states[a:file_type_name]
    else
        return 0
    endif
endfunction

function! s:ORGetCorrectKey(key) dict
    if has_key(self.correct_keys, a:key)
        return self.correct_keys[a:key]
    else
        return 0
    endif
endfunction
    
function! s:ORInstance() dict
    if empty(self.unique_instance)
        let self.unique_instance = {'i':1}
        let l:unique_instance = deepcopy(self)

        let l:unique_instance.RegisterAsObserver = 
                    \function('<SID>ORRegisterAsObserver')
        let l:unique_instance.UnregisterObserver = 
                    \function('<SID>ORUnregisterObserver')
        let l:unique_instance.NotifyObserver = 
                    \function('<SID>ORNotifyObserver')
        let l:unique_instance.RegisterAsSubject    = 
                    \function('<SID>ORRegisterAsSubject')
        let l:unique_instance.UnregisterSubject = 
                    \function('<SID>ORUnregisterSubject')
        let l:unique_instance.SubjectAction = 
                    \function('<SID>ORSubjectAction')
        let l:unique_instance.SaveState = 
                    \function('<SID>ORSaveState')
        let l:unique_instance.GetState = 
                    \function('<SID>ORGetState')

        let l:unique_instance.Instance = function('<SID>VIRTUAL_FUN')

        let l:unique_instance.observers = {}
        let l:unique_instance.subjects  = {}
        let l:unique_instance.subjects_saved_states = {}

        let self.unique_instance = l:unique_instance
    endif

    return self.unique_instance 
endfunction

endif
" END - Mediator class 


" START - Mediator Facade class 
if s:YANP_source_count == 1
let g:YANP_syntax_mediator = 
\{            
    \'Instance'     :function('<SID>YORInstance'),
\}            
endif

if s:YANP_source_count == 0

function! s:YORInstance() dict
    return s:mediator_for_syntax.Instance()
endfunction

endif
" END - Mediator Facade class 


" START - Yanp Observer class 
if s:YANP_source_count == 1
let s:yanp_observer  = 
\{
    \'class_name'       :'yanp_observer',
    \'file_creator'     :0,
    \'registry'         :0,
    \'New'              :function('<SID>YONew'),
    \'Update'           :0,
\}
endif

if s:YANP_source_count == 0

function! s:YONew(file_creator) dict
    let l:new_object = deepcopy(self)

    let l:new_object.file_creator = a:file_creator
    let l:new_object.registry     = {}

    let l:new_object.New    = function('<SID>VIRTUAL_FUN') 
    let l:new_object.Update = function('<SID>YOUpdate')

    return l:new_object
endfunction

function! s:YOUpdate() dict
    if empty(self.registry)
        return 0
    endif

    let l:state = self.registry.GetState(self.file_creator.registry_key)

    return self.file_creator.MakeAction(l:state)
endfunction

endif
" END - Yanp Observer class 


" Start - Subject class 
if s:YANP_source_count == 1
let s:yanp_subject  = 
\{
    \'class_name'       :'yanp_subject',
    \'registry'         :0,
    \'registry_key'     :'',
    \'observers_key'    :'',
    \'New'              :function('<SID>YSNew'),
    \'Notify'           :0,
    \'SaveState'        :0,
    \'GetState'         :0,
    \'ChangeObserver'   :0,
\}
endif

if s:YANP_source_count == 0

function! s:YSNew(registry_key, GetStateFuncRef) dict
    let l:new_object = deepcopy(self)

    let l:new_object.registry_key  = a:registry_key
    " observers_key is a workaround for cases when a syntax plugin cannot
    " distinguish between different subjects, but can timely change
    " an information about an observer to notify. 
    let l:new_object.observers_key = a:registry_key

    let l:new_object.New              = function('<SID>VIRTUAL_FUN')
    let l:new_object.Notify           = function('<SID>YSNotify')
    let l:new_object.SaveState        = function('<SID>YSSaveState')
    let l:new_object.GetState         = a:GetStateFuncRef
    let l:new_object.ChangeObserver   = function('<SID>YSChangeObserver')

    return l:new_object
endfunction

function! s:YSNotify() dict
    eval self.registry.NotifyObserver(self.observers_key)
endfunction

function! s:YSSaveState(state) dict
    eval self.registry.SaveState(a:state, self.observers_key)
endfunction

function! s:YSChangeObserver(new_key) dict
    let self.observers_key = a:new_key
endfunction

endif
" END - Subject class 


" Start - Subject Adapter class 
if s:YANP_source_count == 1
let g:YANP_subject = 
\{
    \'New'          :function('<SID>YSANew'),
\}
endif

if s:YANP_source_count == 0

function! s:YSANew(registry_key, GetStateFuncRef) dict
    return s:yanp_subject.New(a:registry_key, a:GetStateFuncRef)
endfunction

endif
" END - Subject Adapter class 


" START - Current Path Container 
if s:YANP_source_count == 1
let s:current_path_container = 
\{
    \'class_name'            :'current_path_container',
    \'unique_instance'      :{},
    \'paths'                :{},
    \'Instance'             :function('<SID>CPCInstance'),
\}
endif

if s:YANP_source_count == 0
    
function! s:CPCInstance() dict
    if empty(self.unique_instance)
        let self.unique_instance = {'i':1}
        let l:new_object = deepcopy(self)
        let self.unique_instance = l:new_object

        let l:new_object.Instance = 0
       
        let l:new_object.GetMainIndex = function('<SID>CPCGetMainIndex') 
        let l:new_object.GetLastIndex = function('<SID>CPCGetLastIndex')
        let l:new_object.GetTodayFastNote = function('<SID>CPCGetTodayFastNote')
        let l:new_object.GetNewFile       = function('<SID>CPCGetNewFile')

        let l:new_object.UpdateMainIndex     = function('<SID>CPCUpdateMainIndex') 
        let l:new_object.UpdateLastIndex     = function('<SID>CPCUpdateLastIndex') 
        let l:new_object.UpdateTodayFastNote = function('<SID>CPCUpdateTodayFastNote') 
        let l:new_object.UpdateNewFile       = function('<SID>CPCUpdateNewFile')

        let l:new_object.paths['main_index'] = 
\YANP_CorrectPathIfNeeded(s:YANP_main_directory ..'/'..s:YANP_index_page_name)
        let l:new_object.paths['last_index'] = ''
        let l:new_object.paths['today_fast_note'] = ''
        let l:new_object.paths['new_file'] = ''
    endif

    return self.unique_instance
endfunction

function! s:CPCGetMainIndex() dict
    return self.paths['main_index']
endfunction

function! s:CPCGetLastIndex() dict
    return self.paths['last_index']
endfunction

function! s:CPCGetTodayFastNote() dict
    return self.paths['today_fast_note']
endfunction

function! s:CPCGetNewFile() dict
    return self.paths['new_file']
endfunction

function! s:CPCUpdateMainIndex() dict
    let self.paths['main_index'] 
\= YANP_CorrectPathIfNeeded(s:YANP_main_directory ..'/'..s:YANP_index_page_name)
endfunction

function! s:CPCUpdateLastIndex(last_index) dict
    let self.paths['last_index'] 
                \= YANP_CorrectPathIfNeeded(a:last_index)
endfunction

function! s:CPCUpdateTodayFastNote(today_fast_note) dict
    let self.paths['today_fast_note'] 
                \= YANP_CorrectPathIfNeeded(a:today_fast_note)
endfunction

function! s:CPCUpdateNewFile(new_file) dict
    let self.paths['new_file'] 
                \= YANP_CorrectPathIfNeeded(a:new_file)
endfunction

endif
" END - Current Path Container 


" START - YANP global facade
if s:YANP_source_count == 1
let s:global_facade =
\{
    \'class_name'       :'global_facade',
    \'unique_instance'  :{},
    \'Instance'         :function('<SID>GFInstance'),
\}
endif

if s:YANP_source_count == 0

function! s:GFInstance() dict
    if empty(self.unique_instance)
        let self.unique_instance = {'i':1}
        let l:new_object = deepcopy(self)
        let self.unique_instance = l:new_object

        let l:new_object.Instance = 0
        
        let l:new_object.GetRefToDictPathForRegFile = function('<SID>GFGetRefToDictPathForRegFile') 
        let l:new_object.GetRefToDictPathForImg     = function('<SID>GFGetRefToDictPathForImg')
        let l:new_object.GetRefToPathForIndexFile   = function('<SID>GFGetRefToPathForIndexFile')
        let l:new_object.GetRefToPathSelectorGetter = function('<SID>GFGetRefToPathSelectorGetter')

    endif

    return self.unique_instance
endfunction

function! s:GFGetRefToDictPathForRegFile() dict
    return copy(s:YANP_GetDictPathForRegFile)
endfunction

function! s:GFGetRefToDictPathForImg() dict
    return copy(s:YANP_GetDictPathForImg)
endfunction

function! s:GFGetRefToPathForIndexFile() dict
    return copy(s:YANP_GetPathForIndexFile)
endfunction

function! s:GFGetRefToPathSelectorGetter() dict
    return copy(s:YANP_GetPathSelector)
endfunction

endif

" END - YANP global facade


" START - YANP access public facade
if s:YANP_source_count == 1
let g:YANP_access_facade =
\{
    \'class_name'       :'yanp_access_facade',
    \'Instance'         :function('<SID>YGFInstance'),
\}
endif

if s:YANP_source_count == 0

function! s:YGFInstance() dict
    return s:global_facade.Instance()
endfunction

endif

" END - YANP access public facade


" Start - File Creator abstract class 
if s:YANP_source_count == 1
let s:file_creator_abstract =
\{
    \'class_name'       :'file_creator_abstract',
    \'registry_key'     :0,
    \'file_path'        :0,
    \'New'              :0,
    \'MakeAction'       :0,
    \'CreatePath'       :0,
    \'CreateFile'       :0,
    \'AddDefContents'   :0,
\}
endif

if s:YANP_source_count == 0

function! s:FCACreatePath(path) dict
    try
        eval execute("!mkdir -p "..a:path)
    catch /.*/
        throw "CannotCreateDirectory"
    endtry
endfunction

function! s:FCACreateFile(file) dict
    try
        eval execute("!touch "..a:file)
    catch /.*/
        throw "CannotCreateFile"
    endtry

    eval self.AddDefContents(a:file)
    eval s:current_path_container.Instance().UpdateNewFile(a:file)
endfunction

function! s:FCAMakeAction(file_path) dict
    let l:ret = 0

    try
        if empty(glob(a:file_path))
            eval self.CreatePath(fnamemodify(a:file_path, ":h") )
            eval self.CreateFile(a:file_path)
        else
            throw "FileAlreadyExists"
        endif
    catch /CannotCreateDirectory/
        echoerr "CannotCreateDirectory - cannot create a path to" a:file_path
        let l:ret = 1
    catch /CannotCreateFile/
        echoerr "CannotCreateFile - cannot create a file -" a:file_path
        let l:ret = 2
    catch /FileAlreadyExists/
        "echoerr "FileAlreadyExists - this file already exists - " a:file_path
        let l:ret = 3
    endtry

    eval execute("redraw!")

    return l:ret
endfunction

" Class helper functions

function! YANPContentsFileName(file_path)
    return 'file name:      ' .. fnamemodify(a:file_path, ":t") ..'\n'
endfunction

function! YANPContentsTopic(file_path)
    let l:directory = fnamemodify(a:file_path, ":h") 
    let l:cur_idx   = l:directory .. '/' .. s:YANP_index_page_name
   
    let l:topic = 'NO TOPIC' 
    if !empty(glob(l:cur_idx)) && !isdirectory(l:cur_idx)
        let l:topic = fnamemodify(l:directory, ":t")
    endif

    return 'topic:          ' .. l:topic ..'\n'
endfunction

function! YANPContentsFileIndex(file_path)
    let l:index_file 
        \= fnamemodify(a:file_path, ":h") .. "/" .. s:YANP_index_page_name

    if empty(glob(l:index_file)) || isdirectory(l:index_file)
        let l:index_file = 'NO INDEX FILE'
    else
        let l:index_file = g:YANP_GetRegularLinkToThis(l:index_file)
    endif

    return 'index file:     ' .. l:index_file ..'\n'
endfunction

function! YANPContentsDate()
    return 'date:           ' .. strftime("%Y %b %d %X") ..'\n'
endfunction

function! YANPContentsUpperIndex(file_path)
    let l:directory = fnamemodify(a:file_path, ":h") 
    let l:upper_dir = fnamemodify(l:directory, ":h")
    let l:upper_idx = l:upper_dir .. '/' .. s:YANP_index_page_name
   
    let l:u_idx_link = 'NO UPPER INDEX' 
    if !empty(glob(l:upper_idx)) && !isdirectory(l:upper_idx)
        let l:u_idx_link = g:YANP_GetRegularLinkToThis(l:upper_idx)
    endif

    return 'upper index:    ' .. l:u_idx_link ..'\n'
endfunction

function! YANPContentsMainIndex(file_path)
    let l:main_idx = s:current_path_container.Instance().GetMainIndex()
    if l:main_idx == ''
        let l:main_idx = 'NO MAIN INDEX'
    else
        let l:main_idx = g:YANP_GetRegularLinkToThis(l:main_idx) 
    endif

    return 'main index:     ' .. l:main_idx .. '\n'
endfunction

endif
" END - File Creator abstract class 


" Start - Regular File Creator class 
if s:YANP_source_count == 1
let s:regular_file_creator = <SID>Inherit(s:file_creator_abstract,
\{
    \'class_name'       :'regular_file_creator',
    \'New'              :function('<SID>RFCNew'),
\}
\)
endif

if s:YANP_source_count == 0

function! s:RFCNew() dict
    let l:new_object = deepcopy(self)

    let l:new_object.registry_key = s:mediator_for_syntax.
                \GetCorrectKey('Regular')

    let l:new_object.New        = function('<SID>VIRTUAL_FUN')
    let l:new_object.MakeAction = function('<SID>FCAMakeAction')
    let l:new_object.CreatePath = function('<SID>FCACreatePath')
    let l:new_object.CreateFile = function('<SID>FCACreateFile')
    let l:new_object.AddDefContents 
                \= function('<SID>RFCAddDefContents')

    return l:new_object
endfunction

function! s:RFCAddDefContents(file_path) dict
    eval s:YANPAddContentsToRegularFile(a:file_path)
endfunction

" Class helper functions

function! s:AddContentsToRegularFile_DEF(file_path) 
    eval execute
        \('! echo ' .. 
        \'"' ..
        \YANPContentsFileName(a:file_path) ..
        \YANPContentsFileIndex(a:file_path) ..
        \YANPContentsDate() ..
        \'" > ' .. a:file_path)
endfunction

let s:YANPAddContentsToRegularFile = 
            \get(g:, "YANPAddContentsToRegularFile",
            \function("<SID>AddContentsToRegularFile_DEF"))

endif

" END - Regular File Creator class 


" START - Image Path Creator class 
if s:YANP_source_count == 1
let s:image_path_creator = <SID>Inherit(s:file_creator_abstract,
\{
    \'class_name'       :'image_path_creator',
    \'New'              :function('<SID>IPCNew'),
\}
\)
endif

if s:YANP_source_count == 0

function! s:IPCNew() dict
    let l:new_object = deepcopy(self)

    let l:new_object.registry_key = s:mediator_for_syntax.
                \GetCorrectKey('Image')

    let l:new_object.New        = function('<SID>VIRTUAL_FUN')
    let l:new_object.MakeAction = function('<SID>FCAMakeAction')
    let l:new_object.CreatePath = function('<SID>FCACreatePath')
    let l:new_object.CreateFile = function('<SID>VIRTUAL_FUN')
    let l:new_object.AddDefContents 
                \= function('<SID>VIRTUAL_FUN')

    return l:new_object
endfunction

endif
" END - Image Path Creator class 


" START - Index File Creator class 
if s:YANP_source_count == 1
let s:index_file_creator = <SID>Inherit(s:file_creator_abstract,
\{
    \'class_name'       :'index_file_creator',
    \'New'              :function('<SID>IFCNew'),
\}
\)
endif

if s:YANP_source_count == 0

function! s:IFCNew() dict
    let l:new_object = deepcopy(self)

    let l:new_object.registry_key = s:mediator_for_syntax.
                \GetCorrectKey('Index')

    let l:new_object.New        = function('<SID>VIRTUAL_FUN')
    let l:new_object.MakeAction = function('<SID>FCAMakeAction')
    let l:new_object.CreatePath = function('<SID>FCACreatePath')
    let l:new_object.CreateFile = function('<SID>FCACreateFile')
    let l:new_object.AddDefContents 
                \= function('<SID>IFCAddDefContents')

    return l:new_object
endfunction

function! s:IFCAddDefContents(file_path) dict
    eval s:YANPAddContentsToIndexFile(a:file_path)
endfunction

" Class helper functions

function! s:YANPAddContentsToIndexFile_DEF(file_path) 
    eval execute
        \('! echo ' .. 
        \'"' ..
        \YANPContentsTopic(a:file_path) ..
        \YANPContentsUpperIndex(a:file_path) ..
        \YANPContentsMainIndex(a:file_path) ..
        \YANPContentsDate() ..
        \'" > ' .. a:file_path)
endfunction

function! s:YANPAddContentsToMainIndexFile_DEF(file_path) 
    eval execute
        \('! echo ' .. 
        \'"' ..
        \'This is YANP main index file.\n\n'.. 
        \YANPContentsDate()..
        \'" > ' .. a:file_path)
endfunction

let s:YANPAddContentsToIndexFile = 
            \get(g:, "YANPAddContentsToIndexFile",
            \function("<SID>YANPAddContentsToIndexFile_DEF"))

let s:YANPAddContentsToMainIndexFile = 
            \get(g:, "YANPAddContentsToMainIndexFile",
            \function("<SID>YANPAddContentsToMainIndexFile_DEF"))

endif

" END -  Index Creator class 


" START - Selective File Creator class 
if s:YANP_source_count == 1
let s:selective_file_creator = <SID>Inherit(s:file_creator_abstract,
\{
    \'class_name'       :'selective_file_creator',
    \'New'              :function('<SID>SFCNew'),
\}
\)
endif

if s:YANP_source_count == 0

function! s:SFCNew() dict
    let l:new_object = deepcopy(self)

    let l:new_object.registry_key = s:mediator_for_syntax.
                \GetCorrectKey('Selective')

    let l:new_object.New        = function('<SID>VIRTUAL_FUN')
    let l:new_object.MakeAction = function('<SID>VIRTUAL_FUN')
    let l:new_object.CreatePath = function('<SID>VIRTUAL_FUN')
    let l:new_object.CreateFile = function('<SID>VIRTUAL_FUN')
    let l:new_object.AddDefContents 
                \= function('<SID>VIRTUAL_FUN')

    return l:new_object
endfunction

endif

" END - Selective File Creator class 


" START - Fast Note Creator class 
if s:YANP_source_count == 1
let s:fast_note_creator = <SID>Inherit(s:regular_file_creator,
\{
    \'class_name'       :'fast_note_creator',
    \'New'              :function('<SID>FNCNew'),
\}
\)
endif

if s:YANP_source_count == 0

function! s:FNCNew() dict
    let l:new_object = s:regular_file_creator.New() 

    let l:new_object.registry_key = ''
    let l:new_object.class_name   = s:fast_note_creator.class_name

    let l:new_object.AddDefContents 
                \= function('<SID>FNCAddDefContents')

    return l:new_object
endfunction

function! s:FNCAddDefContents(file_path) dict
    eval s:YANPAddContentsToFastNote(a:file_path)
endfunction

" Class helper functions

function! s:YANPAddContentsToFastNote_DEF(file_path) 
    eval execute
        \('! echo ' .. 
        \'"' ..
        \YANPContentsFileName(a:file_path) ..
        \'" > ' .. a:file_path)
endfunction

let s:YANPAddContentsToFastNote = get(g:, "YANPAddContentsToFastNote",
            \function("<SID>YANPAddContentsToFastNote_DEF"))
endif

" END - Fast Note Creator class 


" START - YANP Action abstract class 
if s:YANP_source_count == 1
let s:action_abstract_class =
\{
    \'class_name'       :'action_abstract_class',
    \'file_creator'     :0,
    \'New'              :0,
    \'MakeAction'       :0,
\}
endif

if s:YANP_source_count == 0
endif

" END - YANP Action abstract class 


" START - Fast Note Action class 

if s:YANP_source_count == 1
let s:fast_note_action = <SID>Inherit(s:action_abstract_class,
\{
    \'class_name'       :'fast_note_action',
    \'New'              :function('<SID>FNANew'),
    \'OpenTodayFastNote':0,
\}
\)
endif

if s:YANP_source_count == 0

function! s:FNANew(file_creator) dict
    let l:new_object = deepcopy(self)
    
    let l:new_object.file_creator = a:file_creator

    let l:new_object.New        = function('<SID>VIRTUAL_FUN')
    let l:new_object.MakeAction = function('<SID>FNAMakeAction')
    let l:new_object.OpenTodayFastNote = function('<SID>FNAOpenTodayFastNote')

    return l:new_object
endfunction

function! s:FNAMakeAction() dict
    let l:can_open_fast_note = 0
    let l:path_container     = 
                \s:current_path_container.Instance()

    if empty(l:path_container.GetTodayFastNote())
        let l:fn_path 
          \= s:YANP_fast_notes_dir..'/'..strftime(s:YANP_fast_note_name_format) 
       
        let l:todays_file_exists = 0 
        if empty(glob(l:fn_path))
            let l:ret = self.file_creator.MakeAction(l:fn_path)
        endif

        if l:todays_file_exists == 0
            let l:can_open_fast_note = 1
            eval l:path_container.UpdateTodayFastNote(l:fn_path)
        endif
    else
        let l:can_open_fast_note = 1
    endif

    if l:can_open_fast_note
        eval self.OpenTodayFastNote()
    endif
endfunction

function! s:FNAOpenTodayFastNote() dict
    eval s:YANP_EditFastNote(
                \s:current_path_container.Instance().GetTodayFastNote())
endfunction

" Class helper functions

function! s:EditFileInPopupWin(file_path)
    let l:buf_nr = bufnr(
                \s:current_path_container.Instance().GetTodayFastNote(), 1)
    return popup_create(l:buf_nr,
        \{
            \'title':   fnamemodify(a:file_path, ":t"),
            \'border':  [],
        \}
    \)
endfunction

function! s:EditFileInPreviewWin(file_path)
    if !has("quickfix")
        echoerr "Preview windows are not supported by your Vim! Please see :h YANPCustomization to see how to redefine fast notes opening."
        return
    endif

    eval execute("pedit " .. a:file_path)
    
    if bufnr(a:file_path) != -1
        eval execute("wincmd P")
        eval execute("normal! G")
        if !empty(getline('.'))
            eval execute("normal! o\<Esc>")
        endif
        eval execute("normal! o"..strftime("%T").."\<Esc>o\<Esc>")
    endif

    "let l:buf_nr = bufnr(a:file_path)
    "if 0 == appendbufline(l:buf_nr, line('$', bufwinid(l:buf_nr)), strftime("%T"))  
    "endif
endfunction

function! s:EditFileInRegularWin(file_path)
    eval execute("edit " .. a:file_path)
endfunction

function! YANPFN()
    let l:object = s:fast_note_action.New(s:fast_note_creator.New())
    eval l:object.MakeAction()
endfunction

endif

" END - Fast Note Action class 


" START - Path Selector class 
if s:YANP_source_count == 1
let s:path_select_action = s:Inherit(s:action_abstract_class,
\{
    \'class_name'       :'path_select_action',
    \'path_selector'    :0,
    \'New'              :function('<SID>PSANew'),
    \'DoWhenDone'       :0,
\}
\)
endif

if s:YANP_source_count == 0

function! s:PSANew(file_creator, DoWhenDone, GetSelectionObject) dict
    let l:new_object = deepcopy(self)
    
    let l:new_object.file_creator  = a:file_creator
    let l:new_object.path_selector = a:GetSelectionObject()

    let l:new_object.New        = function('<SID>VIRTUAL_FUN')

    let l:new_object.MakeAction = function('<SID>PSAMakeAction')
    let l:new_object.DoWhenDone = a:DoWhenDone

    return l:new_object
endfunction

function! s:PSAMakeAction() dict

    let l:cur_path = expand("%:p:h")
    let l:menu     = self.path_selector

    eval l:menu.InitContents(extend([".", ".."], readdir(l:cur_path)),
                            \l:cur_path)
    eval l:menu.ChangeBehavior(l:menu.GetNewContents, l:menu.IsDone, 
                              \self.DoWhenDone) 

    eval l:menu.Show()
endfunction

" Class helper functions

function! s:YANPGetPathSelector_DEF()
    return s:menu_customizable_class.Instance()
endfunction

let s:YANP_GetPathSelector =
    \get(g:, 'YANPGetPathSelector', function('<SID>YANPGetPathSelector_DEF'))

endif
" END - Path Selector class 


" START - Path Selector adapter class 
if s:YANP_source_count == 1
let g:YANP_path_selector =
\{
    \'class_name'       :'YANP_path_selector',
    \'New'              :function('<SID>YPSNew'),
\}
endif

if s:YANP_source_count == 0

function! s:YPSNew(DoWhenDone, GetSelectionObject)
    return s:path_select_action.New(s:regular_file_creator.New(), 
                \a:DoWhenDone, a:GetSelectionObject)
endfunction

endif
" END - Path Selector adapter class 


" START - Open Index action 
if s:YANP_source_count == 1
let s:open_index_action = s:Inherit(s:action_abstract_class,
\{
    \'class_name'       :'open_index_action',
    \'unique_instance'  :{},
    \'Instance'         :function('<SID>OIAInstance'),
\}
\)
endif

if s:YANP_source_count == 0

function! s:OIAInstance() dict
    if empty(self.unique_instance)
        let self.unique_instance = {'i':1}
        let l:new_object = deepcopy(self)
        let self.unique_instance = l:new_object

        let l:new_object.Instance = 0

        let l:new_object.OpenMainIndex = function('<SID>OIAOpenMainIndex')
        let l:new_object.OpenLastIndex = function('<SID>OIAOpenLastIndex')
        let l:new_object.OpenNewFile   = function('<SID>OIAOpenNewFile')
    endif

    return self.unique_instance   
endfunction

function! s:OIAOpenMainIndex() dict
    let l:idx_file = s:current_path_container.Instance().GetMainIndex()
    if !empty(l:idx_file)
        eval s:OpenSomeFile(l:idx_file)
    endif
endfunction

function! s:OIAOpenLastIndex() dict
    let l:idx_file = s:current_path_container.Instance().GetLastIndex()
    if !empty(l:idx_file)
        eval s:OpenSomeFile(l:idx_file)
    endif
endfunction

function! s:OIAOpenNewFile() dict
    let l:new_file = s:current_path_container.Instance().GetNewFile()
    if !empty(l:new_file)
        eval s:OpenSomeFile(l:new_file)
    endif
endfunction

" Class helper functions

function! s:YANP_OpenSomeFile_DEF(some_file)
    eval execute("edit "..a:some_file)

endfunction

let s:OpenSomeFile = 
    \get(g:, 'YANPOpenSomeFile', function('<SID>YANP_OpenSomeFile_DEF'))

endif

" END - Open Index action 


" START - Menu customizable class class 

if s:YANP_source_count == 1
let s:menu_customizable_class = 
\{
    \'class_name'           :'menu_customizable_class',
    \'instance_per_tab'     :{},
    \'menu_contents'        :[],
    \'selection'            :'',
    \'contents_idx'         :0,
    \'menu_is_shown'        :0,
    \'Instance'             :function("<SID>MCCInstance"),
    \'InitContents'         :0,
    \'ChangeBehavior'       :0,
    \'Show'                 :0,
    \'ShowMenu'             :0,
    \'UpdateIdx'            :0,
    \'GetNewContents'       :0,
    \'IsDone'               :0,
    \'DoWhenDone'           :0, 
\}
endif


if s:YANP_source_count == 0

function! s:MCCInstance(cur_tab_nr = tabpagenr()) dict
    if !has_key(self.instance_per_tab, a:cur_tab_nr)
        let l:new_object = copy(self)
    
        let l:new_object.menu_is_shown  = 0

        if has("popupwin")
            let l:new_object.ChangeBehavior = function('<SID>MCCChangeBehavior')
            let l:new_object.Show           = function('<SID>MCCShow')
            let l:new_object.ShowMenu       = function('<SID>MCCShowMenu')
            let l:new_object.Update         = function('<SID>MCCUpdate_DEF')
            let l:new_object.InitContents   = function('<SID>MCCInitContents_DEF')
            let l:new_object.GetNewContents = function('<SID>MCCGetNewContents_DEF')
            let l:new_object.IsDone         = function('<SID>MCCIsDone_DEF')
            let l:new_object.DoWhenDone     = function('<SID>MCCDoWhenDone_DEF')
        else
            echoerr self.class_name .. 
            \" - popup windows are not supported by your Vim! Using the object will lead to failure!"
        endif

        let l:new_object.Instance = 0

        eval l:new_object.InitContents()

        let self.instance_per_tab[a:cur_tab_nr] = l:new_object
    endif

    return self.instance_per_tab[a:cur_tab_nr]
endfunction

function! s:MCCChangeBehavior(GetNewContents, IsDone, DoWhenDone) dict
    let self.GetNewContents = a:GetNewContents
    let self.IsDone         = a:IsDone
    let self.DoWhenDone     = a:DoWhenDone
endfunction

function! s:MCCShow() dict
    if !self.menu_is_shown
        eval self.ShowMenu()
    endif
endfunction

function! s:MCCShowMenu() dict
    let self.menu_is_shown = 1
    eval popup_menu(self.menu_contents, 
                   \{'callback' :function('<SID>MCCSelectMenuItem')})
endfunction

function! s:MCCSelectMenuItem(popid, new_index) 
    let l:menu_instance               = s:menu_customizable_class.Instance()
    let l:menu_instance.menu_is_shown = 0

    if a:new_index == -1
        "eval l:menu_instance.InitContents()
        "eval l:menu_instance.DoWhenDone()
        return
    endif

    let l:menu_instance.Update(a:new_index - 1)

    if l:menu_instance.IsDone()
        eval l:menu_instance.DoWhenDone()
    else
        eval l:menu_instance.ShowMenu()
    endif
endfunction

" Class default functions 
function! s:MCCInitContents_DEF(
\new_contents = readdir(expand('~')), selection = expand('~'), index = 0) dict
    if self.menu_is_shown
        return
    endif

    let self.menu_contents      = a:new_contents    
    let self.selection          = a:selection
    let self.contents_idx       = a:index
endfunction

function! s:MCCUpdate_DEF(new_idx) dict
    if self.menu_is_shown
        return
    endif

    let l:selected_item = self.menu_contents[a:new_idx]
    let l:selection     = self.selection

    if l:selected_item == '.'
        "nothing
    elseif l:selected_item == '..'
        let l:new_dir = fnamemodify(l:selection, ":h")
        if isdirectory(l:new_dir)
            let l:selection = l:new_dir
        endif 
    else
        let l:selection = l:selection .. '/' .. l:selected_item
    endif

    if isdirectory(l:selection)
        let self.menu_contents = extend([".", ".."], readdir(l:selection))
    endif
    
    let self.selection    = l:selection
    let self.contents_idx = a:new_idx
endfunction

function! s:MCCGetNewContents_DEF() dict
    if self.menu_is_shown
        return
    endif

    " The function is obsolete.
endfunction

function! s:MCCIsDone_DEF() dict
    let l:file = self.selection
    return !empty(glob(l:file)) && !isdirectory(l:file)
endfunction

function! s:MCCDoWhenDone_DEF() dict
    echom "YANP - default DoWhenDone() in menu . Your selection is - "..self.selection
endfunction

endif

" END - Menu abstract class class 


" START - YANP updater
if s:YANP_source_count == 1
let s:yanp_updater =
\{
    \'class_name'       :'yanp_updater',
    \'unique_instance'  :{},
    \'Instance'         :function('<SID>YUInstance'),
    \'Update'           :0,
\}
endif

if s:YANP_source_count == 0

function! s:YUInstance() dict
    if empty(self.unique_instance)
        let self.unique_instance = {'i':1}
        let l:new_object = deepcopy(self)
        let self.unique_instance = l:new_object

        let l:new_object.Instance = 0

        let l:new_object.Update = function('<SID>YUUpdate')    
    endif

    return self.unique_instance
endfunction

function! s:YUUpdate() dict
    let l:path_container = s:current_path_container.Instance()
    let l:action         = s:index_file_creator.New()

    eval l:path_container.UpdateMainIndex()

    let l:SavedFunc = s:YANPAddContentsToIndexFile
    let s:YANPAddContentsToIndexFile = s:YANPAddContentsToMainIndexFile

    eval l:action.MakeAction(l:path_container.GetMainIndex())
    eval l:action.CreatePath(s:YANP_fast_notes_dir)

    eval execute("redraw!")

    let s:YANPAddContentsToIndexFile = l:SavedFunc
endfunction

endif
" END - YANP updater



" ---------- YANP init functions

if s:YANP_source_count == 1

function! s:CreateObjects()
    let l:mediator = g:YANP_syntax_mediator.Instance()

    let l:regular_observer 
                \= s:yanp_observer.New(s:regular_file_creator.New())
    let l:image_observer 
                \= s:yanp_observer.New(s:image_path_creator.New())
    let l:index_observer 
                \= s:yanp_observer.New(s:index_file_creator.New())
    let l:selective_observer 
                \= s:yanp_observer.New(s:selective_file_creator.New())

    eval l:mediator.RegisterAsObserver(l:regular_observer)
    eval l:mediator.RegisterAsObserver(l:image_observer)
    eval l:mediator.RegisterAsObserver(l:index_observer)
    eval l:mediator.RegisterAsObserver(l:selective_observer)
endfunction

function! s:SetAutoGroup()
    augroup yanpaugroup
        autocmd!

        execute "autocmd BufLeave *"..s:YANP_extention.. 
            \" eval s:current_path_container.Instance().UpdateLastIndex("..
            \"expand('<afile>'))"
    
    augroup END
endfunction

endif



" ---------- YANP main function

let s:YANP_source_count += 1
if s:YANP_source_count < s:YANP_max_sources
    source <sfile>
else
    eval <SID>CreateObjects()
    eval <SID>SetAutoGroup()
    let g:YANP_plugin_is_loaded = 1
endif

