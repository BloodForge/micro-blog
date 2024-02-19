package com.example.microblog.repos;

import com.example.microblog.domain.Comment;
import com.example.microblog.domain.Message;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface CommentRepo extends CrudRepository<Comment,Long> {
    List<Comment> findByMessage(Message message);
}
