//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBNewsViewController.h"

@interface EBNewsViewController ()

@end

@implementation EBNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    diputadosNews = [[NSMutableArray alloc]init];
    senadoresNews = [[NSMutableArray alloc]init];
    
    NSString *queryString = @"//item";
    
    
    [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://news.google.com.mx/news?q=diputados%20mexico&output=rss"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){ 
            TFHpple *parser = [TFHpple hppleWithHTMLData:data];
            NSArray *nodes = [parser searchWithXPathQuery:queryString];
            for (TFHppleElement *element in nodes) {
                NSString *title = [[[[[element children]objectAtIndex:0]children]objectAtIndex:0]content];
                NSString *link = [[[element children]objectAtIndex:2]content];
                //NSLog(@"Title: %@ Link: %@", title, link);
                
                NSDictionary *dic = @{@"title": title, @"link": link};
                [diputadosNews addObject:dic];
            }
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
            [self.tableView reloadData];
        }
        else if (error){
            NSLog(@"%@",error);
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
        }
    }];
    
    [[EBProgressIndicator sharedProgressIndicator]addProcessToQueue];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://news.google.com.mx/news?q=senadores%20mexico%20camara&output=rss"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){
            TFHpple *parser = [TFHpple hppleWithHTMLData:data];
            NSArray  *nodes = [parser searchWithXPathQuery:queryString];
            for (TFHppleElement *element in nodes) {
                NSString *title = [[[[[element children]objectAtIndex:0]children]objectAtIndex:0]content];
                NSString *link = [[[element children]objectAtIndex:2]content];
                //NSLog(@"Title: %@ Link: %@", title, link);
                
                NSDictionary *dic = @{@"title": title, @"link": link};
                [senadoresNews addObject:dic];
                
            }
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
            [self.tableView reloadData];
        }
        else if (error){
            NSLog(@"%@",error);
            [[EBProgressIndicator sharedProgressIndicator]removeProcessFromQueue];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return [senadoresNews count];
    }else{
        return [diputadosNews count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.numberOfLines = 3;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Senadores
    if (indexPath.section==0) {
        cell.textLabel.text = [[senadoresNews objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    //Diputados
    }else if(indexPath.section==1){
        cell.textLabel.text = [[diputadosNews objectAtIndex:indexPath.row]objectForKey:@"title"];
        
    }
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0 && senadoresNews.count) {
        return @"Últimas noticias sobre los senadores";
    
    }else if (section==1 && diputadosNews.count){
        return @"Últimas noticias sobre los diputados";
    }else{
        return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSString *title = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
        
        NSString *urlString = [[senadoresNews objectAtIndex:indexPath.row]objectForKey:@"link"];
        
        //NSLog(@"Original URL: %@", urlString);
        
        NSString *pstring = [[urlString componentsSeparatedByString:@"http"]objectAtIndex:2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http%@", pstring]];
        
        EBBrowserViewController *b = [[EBBrowserViewController alloc]initWithTitle:title andURL:url];
        b.showMobilizerSwitch = YES;
        
        [self.navigationController pushViewController:b animated:YES];
    }else if(indexPath.section==1){
        NSString *title = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
        
        NSString *urlString = [[diputadosNews objectAtIndex:indexPath.row]objectForKey:@"link"];
        
        //NSLog(@"Original URL: %@", urlString);
        
        NSString *pstring = [[urlString componentsSeparatedByString:@"http"]objectAtIndex:2];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http%@", pstring]];
        
        EBBrowserViewController *b =[[EBBrowserViewController alloc]initWithTitle:title andURL:url];
        b.showMobilizerSwitch = YES;
        
        [self.navigationController pushViewController:b animated:YES];
    }
}

@end
