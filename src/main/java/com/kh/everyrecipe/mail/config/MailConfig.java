package com.kh.everyrecipe.mail.config;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

@Configuration
public class MailConfig {
	
	@Bean
	public JavaMailSender mailSender() {
		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		
		//접속정보 설정
		//TODO: api property 파일과 연계
		mailSender.setHost("smtp.gmail.com"); //어느 이메일(메일서버)를 이용하여 보낼것인가?, 사설 메일 서버가 없기 때문에 다른 메일을 사용한다.
		mailSender.setPort(587);//메일서버서 사용하는 포트 명은 지정되어 있음.
		mailSender.setUsername("kjch5908@gmail.com");//인증번호 보낼 이메일 번호?계정?
		mailSender.setPassword("kpukhizqefxfdtoq");//위 이메일 번호의 비밀번호
		
		//연결을 위한 접속 관리 정보
		Properties pro = new Properties();
		pro.setProperty("mail.transport.protocol", "smtp");//전송 프로토콜 지정
		pro.setProperty("mail.smtp.auth", "true");//SMTP 프로토콜을 인증 할것인가 여부
		pro.setProperty("mail.smtp.starttls.enable", "true");//암호화 통신 관련 사용 여부(true로 해줘야 원활히 동작 = 구글은 암호화 통신을 하기 때문)
		mailSender.setJavaMailProperties(pro);
		return mailSender;


		
		
	}
}
