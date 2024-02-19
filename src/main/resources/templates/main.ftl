<#import "parts/common.ftl" as c>

<@c.page>
<div class="form-row">
    <div class="form-group col-md-6">
        <form method="get" action="/main" class="form-inline">
            <input type="text" name="filter" class="form-control" value="${filter?ifExists}" placeholder="Search by tag">
            <button type="submit" class="btn btn-primary ml-2">Search</button>
        </form>
    </div>
</div>

<a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">
    Add new Message
</a>
<div class="collapse <#if message??>show</#if>" id="collapseExample">
    <div class="form-group mt-3">
        <form method="post" enctype="multipart/form-data">
            <div class="form-group">
                <input type="text" class="form-control ${(textError??)?string('is-invalid', '')}"
                       value="<#if message??>${message.text}</#if>" name="text" placeholder="Введите сообщение" />
                <#if textError??>
                <div class="invalid-feedback">
                    ${textError}
                </div>
                </#if>
            </div>
            <div class="form-group">
                <input type="text" class="form-control"
                       value="<#if message??>${message.tag}</#if>" name="tag" placeholder="Тэг">
                <#if tagError??>
                    <div class="invalid-feedback">
                        ${tagError}
                    </div>
                </#if>
            </div>
            <div class="form-group">
                <div class="custom-file">
                    <input type="file" name="file" id="customFile">
                    <label class="custom-file-label" for="customFile">Choose file</label>
                </div>
            </div>
            <input type="hidden" name="_csrf" value="${_csrf.token}" />
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Добавить</button>
            </div>
        </form>
    </div>
</div>

<div class="card-columns">
    <#list messages as message>
    <div class="card my-3">
        <#if message.filename??>
        <img src="/img/${message.filename}" class="card-img-top">
        </#if>
        <div class="m-2">
            <span>${message.text}</span>
            <i>${message.tag}</i>
        </div>
        <div class="card-footer text-muted">
            ${message.authorName}
        </div>
    </div>
    <#else>
    No message
    </#list>
</div>


<div class="card-footer text-muted">
    ${message.authorName}
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#commentModal${message.id}">
        Оставить комментарий
    </button>
</div>

<!-- Модальное окно для комментариев -->
<div class="modal fade" id="commentModal${message.id}" tabindex="-1" role="dialog" aria-labelledby="commentModalLabel${message.id}" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="commentModalLabel${message.id}">Новый комментарий</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Закрыть">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
                <form method="post" action="/addComment">
                    <div class="form-group">
                        <label for="commentText${message.id}">Текст комментария</label>
                        <textarea class="form-control" id="commentText${message.id}" name="text" rows="3"></textarea>
                    </div>
                    <input type="hidden" name="messageId" value="${message.id}" />
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-primary">Отправить комментарий</button>
                </form>
            </div>
        </div>
    </div>
</div>




</@c.page>
