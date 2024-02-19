package com.example.microblog.controller;

import com.example.microblog.domain.Comment;
import com.example.microblog.domain.Message;
import com.example.microblog.domain.User;
import com.example.microblog.repos.CommentRepo;
import com.example.microblog.repos.MessageRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
public class MainController {
    @Autowired
    private MessageRepo messageRepo;
    @Autowired
    private CommentRepo commentRepo;

    @Value("${upload.path}")
    private String uploadPath;

    @GetMapping("/")
    public String greeting(Map<String, Object> model) {
        return "greeting";
    }

    @GetMapping("/main")
    public String main(@RequestParam(required = false, defaultValue = "") String filter, Model model) {
        Iterable<Message> messages = messageRepo.findAll();

        if (filter != null && !filter.isEmpty()) {
            messages = messageRepo.findByTag(filter);
        } else {
            messages = messageRepo.findAll();
        }

        Map<Message, List<Comment>> messageComments = new HashMap<>();
        for (Message message : messages) {
            List<Comment> comments = commentRepo.findByMessage(message);
            messageComments.put(message, comments);
        }

        model.addAttribute("messages", messages);
        model.addAttribute("messageComments", messageComments);
        model.addAttribute("filter", filter);


        return "main";
    }

    @PostMapping("/main")
    public String add(
            @AuthenticationPrincipal User user,
            @Valid Message message,
            BindingResult bindingResult,
            Model model,
            @RequestParam("file") MultipartFile file
    ) throws IOException {
        message.setAuthor(user);

        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);

            model.mergeAttributes(errorsMap);
            model.addAttribute("message", message);
        } else {
            if (file != null && !file.getOriginalFilename().isEmpty()) {
                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String uuidFile = UUID.randomUUID().toString();
                String resultFilename = uuidFile + "." + file.getOriginalFilename();

                file.transferTo(new File(uploadPath + "/" + resultFilename));

                message.setFilename(resultFilename);
            }

            model.addAttribute("message", null);

            messageRepo.save(message);
        }

        Iterable<Message> messages = messageRepo.findAll();

        model.addAttribute("messages", messages);

        return "redirect:/main";
    }

    @PostMapping("/addComment")
    public String addComment(
            @AuthenticationPrincipal User user,
            @RequestParam("messageId") Message message,
            @RequestParam("text") String text,
            Model model
    ) {



        Comment comment = new Comment(text, user, message);
        commentRepo.save(comment);

        model.addAttribute("comment", comment);

        return "redirect:/main";
    }

}
